/* TODO:
   - Styling of node header
   - Handle internal links: #NODE-NAME.ID-NAME
   - set location.has husefully; use initial value  */

/* JavaScript mostly to set up a table-of-contents sidebar, using an
   <iframe>.  The <iframe> sidebar can be explicitly enabled if you
   use the hash "#sidebar" or "#sidebar=yes"; or explicitly disabled
   with "#sidebar=no".  The default is to enable the sidebar except
   when using a ebook-reader (as detected by the property
   navigator.epubReadingSystem), since ebook-readers generally provide
   their own table-of-contents.  */

import * as sidebar from "./sidebar";

import {
  absolute_url_p,
  basename,
  inside_iframe_p,
  inside_index_page_p
} from "./utils";

import {
  clear_toc_styles,
  fix_link,
  main_filename,
  scan_toc
} from "./toc";

import polyfill from "./polyfill";

/* Object used for retrieving navigation links.  This is only used
   from the index page.  */
let loaded_nodes = {
  /* Dictionary associating page ids to next, prev, up link ids.  */
  data: {},
  /* Page id of the current visible page.  */
  current: null
};

/* Initialize the top level "index.html" DOM.  */
function
on_index_load (evt)
{
  main_filename.val = basename (window.location.pathname);

  /* Move contents of <body> into a a fresh <div>.  */
  var body = document.body;
  var div = document.createElement ("div");
  window.selectedDivNode = div;
  div.setAttribute ("id", "index");
  div.setAttribute ("node", "index");
  for (let ch = body.firstChild; ch !== null; ch = body.firstChild)
    div.appendChild (ch);
  body.appendChild (div);

  if (sidebar.use_sidebar (window.location.hash))
    sidebar.instance.render ({ current: "index", visible: true });

  fix_links (document.links);
  let url = "index";
  let item = navigation_links (document);
  top.postMessage ({ message_kind: "cache-document", url, item }, "*");
  loaded_nodes.current = url;
}

/* Initialize the DOM for generic pages loaded in the context of an
   iframe.  */
function
on_iframe_load (evt)
{
  main_filename.val = basename (window.name, /#.*/);
  fix_links (document.links);
  let url = basename (window.location.pathname, /[.]x?html$/);
  let item = navigation_links (document);
  top.postMessage ({ message_kind: "cache-document", url, item }, "*");
}

/* Modify LINKS to handle the iframe based navigation properly.
   relative links will be opened inside the corresponding iframe and
   absolute links will be opened in a new tab.  LINKS must be an array
   or a collection of nodes.  Return the number of nodes fixed.  */
function
fix_links (links)
{
  let count = 0;
  for (let i = 0; i < links.length; i += 1)
    {
      let link = links[i];
      let href = link.getAttribute ("href");
      if (href)
        {
          fix_link (link, href);
          count += 1;
        }
    }

  return count;
}

/* Retrieve PREV, NEXT, and UP links and Return a object containing references
   to those links.  */
var navigation_links = (function () {
  /* Dictionary associating an 'accesskey' property to its navigation id.  */
  let dict = { n: "next", p: "prev", u: "up" };

  return function (content) {
    let links = Array.from (content.querySelectorAll ("footer a"));

    /* links have the form MAIN_FILE.html#FRAME-ID.  For convenience
       we only store FRAME-ID.  */
    return links.reduce ((acc, link) => {
      let nav_id = dict[link.getAttribute ("accesskey")];
      if (nav_id)
        acc[nav_id] = link.getAttribute ("href").replace (/.*#/, "");
      return acc;
    }, {});
  };
} ());

function
load_page (url, hash)
{
  var node_name = url.replace (/[.]x?html.*/, "");
  var path =
      (window.location.pathname + window.location.search).replace (/#.*/, "")
      + hash;
  var div = document.getElementById (node_name);
  var iframe = div.firstChild;
  if (iframe === null)
    {
      iframe = document.createElement ("iframe");
      iframe.setAttribute ("class", "node");
      iframe.setAttribute ("name", path);
      iframe.setAttribute ("src", url);
      div.appendChild (iframe);
    }
  else if (iframe.nodeName == "IFRAME")
    {
      let msg = { message_kind: "scroll-to", url };
      iframe.contentWindow.postMessage (msg, "*");
    }

  let msg = { message_kind: "update-sidebar", selected: node_name };
  sidebar.instance.element.contentWindow.postMessage (msg, "*");
  window.history.pushState ("", document.title, path);
  if (window.selectedDivNode != div)
    {
      if (window.selectedDivNode)
        window.selectedDivNode.setAttribute ("hidden", "true");
      div.removeAttribute ("hidden");
      loaded_nodes.current = node_name;
      window.selectedDivNode = div;
    }
}

function
receive_message (event)
{
  let data = event.data;
  switch (data.message_kind)
    {
    case "node-list":           /* from sidebar to top frame */
      {
        for (var i = 0; i < data.length; i += 1)
          {
            let name = data[i];
            if (name == "index")
              continue;
            let div = document.createElement ("div");
            div.setAttribute ("id", name);
            div.setAttribute ("node", name);
            div.setAttribute ("hidden", "true");
            document.body.appendChild (div);
          }
        if (window.location.hash)
          {
            let hash = window.location.hash;
            let url = (hash.includes (".")) ?
                hash.replace (/#(.*)[.](.*)/, "$1.xhtml#$2") :
                hash.replace (/#/, "") + ".xhtml";
            load_page (url, hash);
          }
        break;
      }
    case "load-page":           /* from click handler to top frame */
      {
        if (!data.nav)         /* not a NEXT, PREV, UP link */
          load_page (data.url, data.hash);
        else
        {
          let ids = loaded_nodes.data[loaded_nodes.current];
          let link_id = ids[data.nav];
          if (link_id)
            load_page (link_id + ".xhtml", "");
        }
        break;
      }
    case "scroll-to":           /* top window to node window */
      {
        let url = data.url;
        window.location.hash = (url.includes ("#")) ?
          url.replace (/.*#/, "") : "";
        break;
      }
    case "update-sidebar":
      {
        let selected = data.selected;
        clear_toc_styles (document.body);
        let filename = (selected == "index") ?
            "index.html" : (selected + ".xhtml");
        scan_toc (document.body, filename);
        break;
      }
    case "cache-document":
      loaded_nodes.data[data.url] =
        Object.assign ({}, loaded_nodes.data[data.url], data.item);
      break;
    default:
      break;
    }
}

function
on_click (evt)
{
  for (var target = evt.target; target !== null; target = target.parentNode)
    {
      if ((target instanceof Element) && target.matches ("a"))
        {
          let href = target.getAttribute ("href");
          if (!absolute_url_p (href))
            {
              let url = href.replace (/.*#/, "") || "index";
              if (url.includes ("."))
                url = url.replace (/[.]/, ".xhtml#");
              else
                url += ".xhtml";
              let hash = href.replace (/.*#/, "#");
              if (hash == "index.html")
                hash = "";
              top.postMessage ({ message_kind: "load-page", url, hash }, "*");
              evt.preventDefault ();
              evt.stopPropagation ();
              return;
          }
        }
    }
}

function
on_unload (evt)
{
  var request = new XMLHttpRequest ();
  request.open ("GET", "(WINDOW-CLOSED)");
  request.send (null);
}

/* Handle Keyboard 'keypress' events.  */
var on_keypress = (function () {
  /* Dictionary associating an Event 'key' property to its navigation id.  */
  let dict = {
    n: "next",
    p: "prev",
    u: "up",
    "]": "forward",
    "[": "backward"
  };

  return function (evt) {
    let nav = dict[evt.key];
    if (nav)
      top.postMessage ({ message_kind: "load-page", nav }, "*");
  };
} ());

/* Don't do anything if the current script is launched from a non-iframed page
   which is different from "index.html".  */
if (inside_iframe_p () || inside_index_page_p (window.location.pathname))
{
  polyfill.register ();

  if (!inside_iframe_p ())
    {
      window.addEventListener ("load", on_index_load, false);
      window.addEventListener ("message", receive_message, false);
    }
  else if (window.name == "slider")
    {
      window.addEventListener ("load", sidebar.on_load, false);
      window.addEventListener ("message", sidebar.on_message, false);
    }
  else
    {
      window.addEventListener ("load", on_iframe_load, false);
      window.addEventListener ("message", receive_message, false);
    }

  window.addEventListener ("beforeunload", on_unload, false);
  window.addEventListener ("click", on_click, false);
  window.addEventListener ("keypress", on_keypress, false);
}
