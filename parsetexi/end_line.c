/* Copyright 2010, 2011, 2012, 2013, 2014, 2015
   Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>. */

#include <stdlib.h>
#include <string.h>

#include "parser.h"
#include "tree.h"
#include "text.h"
#include "input.h"
#include "convert.h"
#include "labels.h"
#include "indices.h"

// 5467, also in Common.pm 1334
// TODO: Check the behaviour here is the same
/* Return a new element whose contents are the same as those of ORIGINAL,
   but with some elements representing empty spaces removed.  Elements like 
   these are used to represent some of the "content" extra keys. */
ELEMENT *
trim_spaces_comment_from_content (ELEMENT *original)
{
  ELEMENT *trimmed;
  int i;

  trimmed = new_element (ET_NONE);
  trimmed->parent_type = route_not_in_tree;
  for (i = 0; i < original->contents.number; i++)
    {
      if (original->contents.list[i]->type
          != ET_empty_spaces_after_command
          && original->contents.list[i]->type != ET_spaces_at_end)
        {
          /* FIXME: Is this safe to serialize? */
          /* For example, if there are extra keys in the elements under each 
             argument?  They may not be set in a copy.
             Hopefully there aren't many extra keys set on commands in 
             node names. */
          add_to_element_contents (trimmed, original->contents.list[i]);
        }
    }

  return trimmed;
}

// 5475
ELEMENT *
parse_line_command_args (ELEMENT *line_command)
{
  ELEMENT *line_args;
  ELEMENT *arg = line_command->args.list[0];
  ELEMENT *argarg = 0;
  enum command_id command = line_command->cmd;
  char *line;
  int i;

  line_args = new_element (ET_NONE);

  i = 0;
  while (i < arg->contents.number)
    {
      /* TODO: Ignore all the elements checked in 
         trim_spaces_comment_from_content. */

      if (contents_child_by_index(arg, i)->type
            == ET_empty_spaces_after_command
          || contents_child_by_index(arg, i)->type == ET_spaces_at_end)
        {
          i++;
          continue;
        }
      if (!argarg)
        {
          argarg = contents_child_by_index(arg, i);
          i++;
          continue;
        }
      else
        {
          /* Error - too many arguments. */
          abort ();
        }
    }
  if (!argarg)
    {
      abort();
    }

  if (argarg->text.end == 0)
    abort ();

  command = line_command->cmd;
  line = argarg->text.text;

  switch (command)
    {
    case CM_alias:
    case CM_definfoenclose:
    case CM_columnfractions:
      {
        ELEMENT *new;
        char *p = line, *q;
        while (1)
          {
            p += strspn (p, whitespace_chars);
            if (!*p)
              break;
            q = strpbrk (p, whitespace_chars);
            if (!q)
              q = p + strlen (p);
            new = new_element (ET_NONE);
            text_append_n (&new->text, p, q - p);
            p = q;
            add_to_element_contents (line_args, new);
          }

      }
    case CM_sp:
    case CM_defindex:
    case CM_defcodeindex:
    case CM_synindex:
    case CM_syncodeindex:
    case CM_printindex:
    case CM_everyheadingmarks:
    case CM_everyfootingmarks:
    case CM_evenheadingmarks:
    case CM_oddheadingmarks:
    case CM_evenfootingmarks:
    case CM_oddfootingmarks:
    case CM_fonttextsize:
    case CM_footnotestyle:
    case CM_setchapternewpage:
    case CM_need:
    case CM_paragraphindent:
    case CM_firstparagraphindent:
    case CM_exampleindent:
      {
      }
    case CM_frenchspacing:
    case CM_xrefautomaticsectiontitle:
    case CM_codequoteundirected:
    case CM_codequotebacktick:
    case CM_deftypefnnewline:
      {
        /* Argument is either "on" or "off". */
      }
    case CM_kbdinputstyle:
    case CM_allowcodebreaks:
    case CM_urefbreakstyle:
    case CM_headings:
    default:
      ;
    }
  return line_args;
}

// 2257
/* NODE->contents is the Texinfo for the specification of a node.  This
   function sets three fields on the returned object:

     manual_content - Texinfo tree for a manual name extracted from the
                      node specification.
     node_content - Texinfo tree for the node name on its own
     normalized - a string with the node name after HTML node name
                  normalization is applied

   Objects returned from this function are used as an 'extra' key in a
   few places: the elements of a 'nodes_manuals' array (itself an extra key),
   the 'menu_entry_node' key on a 'menu_entry' element (not to be confused
   with an ET_menu_entry_node element, which occurs in the args of a 
   'menu_entry' element), and in the 'node_argument' key of a cross-reference 
   command (like @xref). */
NODE_SPEC_EXTRA *
parse_node_manual (ELEMENT *node)
{
  NODE_SPEC_EXTRA *result;
  ELEMENT *trimmed;
  ELEMENT *manual;

  result = malloc (sizeof (NODE_SPEC_EXTRA));
  result->manual_content = 0;
  trimmed = trim_spaces_comment_from_content (node);

  /* If the content starts with a '(', try to get a manual name. */
  if (trimmed->contents.number > 0 && trimmed->contents.list[0]->text.end > 0
      && trimmed->contents.list[0]->text.text[0] == '(')
    {
      /* The Perl code here accounts for matching parentheses in the manual 
         name.  The Info reader also handles this, for whatever reason. */

      ELEMENT *e;
      char *closing_bracket;

      manual = new_element (ET_NONE);

      /* If the first contents element is "(" alone, discard it, otherwise
         remove the leading "(". */
      if (trimmed->contents.list[0]->text.end > 1)
        {
          /* Replace the first element with another element with the leading
             "(" removed. */
          ELEMENT *first;
          first = malloc (sizeof (ELEMENT));
          memcpy (first, trimmed->contents.list[0], sizeof (ELEMENT));
          first->text.text = malloc (first->text.space);
          memcpy (first->text.text,
                  trimmed->contents.list[0]->text.text + 1,
                  trimmed->contents.list[0]->text.end - 1);
          first->text.end--;
          trimmed->contents.list[0] = first;
        }
      else
        {
          (void) remove_from_contents (trimmed, 0);
          /* Note the removed element still is present in the original
             'node' argument. */
        }

      while (trimmed->contents.number > 0)
        {
          ELEMENT *e = remove_from_contents (trimmed, 0);

          if (e->text.end == 0
              || !(closing_bracket = strchr (e->text.text, ')')))
            {
              /* Put this element in the manual contents. */
              add_to_element_contents (manual, e);
            }
          else /* ')' in text - possible end of filename component */
            {
              /* Split the element in two, putting the part before the "("
                 in the manual name, leaving the part afterwards for the
                 node name. */
              ELEMENT *before, *after;

              before = new_element (ET_NONE);
              text_append_n (&before->text, e->text.text,
                             closing_bracket - e->text.text);
              add_to_element_contents (manual, before);

              /* Skip ')' and any following whitespace.
                 Note that we don't manage to skip any multibyte
                 UTF-8 space characters here. */
              closing_bracket++;
              closing_bracket += strspn (closing_bracket, whitespace_chars);
              if (*closing_bracket)
                {
                  after = new_element (ET_NONE);
                  text_append_n (&after->text, closing_bracket,
                                 e->text.text + e->text.end - closing_bracket);

                  insert_into_contents (trimmed, after, 0);
                }
              break;
            }
        }

      result->manual_content = manual;
    }

  /* If anything left, it is the node name. */
  if (trimmed->contents.number > 0)
    {
      result->node_content = trimmed;
      result->normalized = convert_to_normalized (trimmed);
    }
  return result;
}

/* Actions to be taken at the end of a line that started a block that
   has to be ended with "@end". */
ELEMENT *
end_line_starting_block (ELEMENT *current)
{
  enum context c;
  // pop and check context_stack
  c = pop_context ();
  if (c != ct_line)
    {
      // bug
      abort ();
    }

  // 2881
  if (current->parent->cmd == CM_multitable)
    {
      /* Parse prototype row for a @multitable.  Handling
         of @columnfractions is done elsewhere. */

      /* TODO: Need to set both 'prototypes' and 'prototypes_line' 
         values.  */

      int i;
      ELEMENT *prototypes = new_element (ET_NONE);
      prototypes->parent_type = route_not_in_tree;

      for (i = 0; i < current->contents.number; i++)
        {
          ELEMENT *e = contents_child_by_index(current, i);

          if (e->type == ET_bracketed)
            {
              /* Copy and change the type of the element. */

              ELEMENT *new;
              new = malloc (sizeof (ELEMENT));
              memcpy (new, e, sizeof (ELEMENT));
              new->type = ET_bracketed_multitable_prototype;
              add_to_element_contents (prototypes, new);
            }
          else if (e->text.end > 0)
            {
              /* TODO: Split the text up by whitespace. */

              if (e->text.text[strspn (e->text.text, whitespace_chars)])
                {
                  ELEMENT *new;
                  new = malloc (sizeof (ELEMENT));
                  memcpy (new, e, sizeof (ELEMENT));
                  new->type = ET_row_prototype;
                  add_to_element_contents (prototypes, new);
                }
            }
          else
            {
              abort (); /*TODO*/
            }
        }

      add_extra_key_contents (current->parent, "prototypes", prototypes);
    }

  if (current->parent->cmd == CM_float) // 2943
    {
    }
  current = current->parent; //2965

  /* Don't consider empty argument of block @-command as argument,
     reparent them as contents. */
  if (current->args.list[0]->contents.number > 0
      && current->args.list[0]->contents.list[0]->type
         == ET_empty_line_after_command)
    {
      ELEMENT *e;
      e = current->args.list[0]->contents.list[0];
      insert_into_contents (current, e, 0);
      // TODO: Free lists?
      current->args.number = 0;
    }

  if (command_flags(current) & CF_blockitem) // 2981
    {
      if (current->cmd == CM_enumerate)
        {
          /* TODO: Can have e.g. 7, "A", or "a". */
          add_extra_string (current, "enumerate_specification", "1");
        }
      else if (item_line_command (current->cmd)) // 3002
        {
          // check command_as_argument registered in 'extra', and
          // that it accepts arguments in braces
        }

      if (current->cmd == CM_itemize) // 3019
        {
          // check that command_as_argument is alone on the line
        }

      // check if command_as_argument isn't an accent command

      /* 3052 - if no command_as_argument given, default to @bullet for
         @itemize, and @asis for @table. */

      {
        ELEMENT *bi = new_element (ET_before_item);
        add_to_element_contents (current, bi);
        current = bi;
      }
    } /* CF_blockitem */

  // 3077
  if (command_flags(current) & CF_menu)
    {
      /* Start reading a menu.  Processing will continue in
         handle_menu in menus.c. */

      ELEMENT *menu_comment = new_element (ET_menu_comment);
      add_to_element_contents (current, menu_comment);
      current = menu_comment;
      debug ("MENU COMMENT OPEN");
      push_context (ct_preformatted);
    }
  current = begin_preformatted (current);

  return current;
}

/* Actions to be taken at the end of an argument to a line command
   not starting a block. */
static ELEMENT *
end_line_misc_line (ELEMENT *current)
{
  enum command_id cmd_id;
  int arg_type;
  enum context c;
  ELEMENT *misc_cmd;
  char *end_command = 0;
  enum command_id end_id;

  isolate_last_space (current, 0);

  current = current->parent;
  misc_cmd = current;
  cmd_id = current->cmd;
  if (!cmd_id)
    abort ();

  arg_type = command_data(cmd_id).data;
   
  /* Check 'line' is top of the context stack */
  c = pop_context ();
  if (c != ct_line)
    {
      /* error */
      abort ();
    }

  // 3114
  debug ("MISC END %s", command_data(cmd_id).cmdname);

  if (arg_type > 0)
    {
      ELEMENT *args = parse_line_command_args (current);
      add_extra_key_misc_args (current, "misc_args", args);
    }
  else if (arg_type == MISC_text) /* 3118 */
    {
      char *text;
     
      /* argument string has to be parsed as Texinfo. This calls convert in 
         Common/Text.pm on the first element of current->args. */
      /* however, this makes it impossible to decouple the parser and 
         output stages...  Any use of Texinfo::Convert is problematic. */

      if (current->args.number > 0)
        text = text_convert (current->args.list[0]);
      else
        text = "foo";

      if (!strcmp (text, ""))
        {
          /* 3123 warning - missing argument */
          abort ();
        }
      else
        {
          if (current->cmd == CM_end) /* 3128 */
            {
              char *line = text;

              /* Set end_command - used below. */
              end_command = read_command_name (&line);

              /* Check argument meets format of a Texinfo command
                 (alphanumberic character followed by alphanumeric 
                 characters or hyphens. */

              /* Check if argument is a block Texinfo command. */
              end_id = lookup_command (end_command);
              if (end_id == 0 || !(command_data(end_id).flags & CF_block))
                {
                  /* error - unknown @end */
                }
              else
                {
                  debug ("END BLOCK %s", end_command);
                  /* 3140 Handle conditional block commands (e.g.  
                     @ifinfo) */

                  /* If we are in a non-ignored conditional, there is not
                     an element for the block in the tree; it is recorded 
                     in the conditional stack.  Pop it and check it is the 
                     same as the one given in the @end line. */

                  if (command_data(end_id).data == BLOCK_conditional)
                    {
                      if (conditional_number > 0)
                        {
                          enum command_id popped;
                          popped = pop_conditional_stack ();
                          if (popped != end_id)
                            abort ();
                        }
                    }
                }
            }
          else if (current->cmd == CM_include) /* 3166 */
            {
              debug ("Include %s", text);
              input_push_file (text);
            }
          else if (current->cmd == CM_documentencoding)
            /* 3190 */
            {
            }
          else if (current->cmd == CM_documentlanguage)
            /* 3223 */
            {
            }
        }
    }
  else if (current->cmd == CM_node) /* 3235 */
    {
      int i;
      ELEMENT *arg;
      ELEMENT *first_arg;

      NODE_SPEC_EXTRA **nodes_manuals;

      /* Construct 'nodes_manuals' array.  This is an 'extra' reference to 
         an array that doesn't exist anywhere else. */
      nodes_manuals = malloc (sizeof (NODE_SPEC_EXTRA *) * 2);
      nodes_manuals[1] = 0;

      first_arg = current->args.list[0];
      nodes_manuals[0] = parse_node_manual (first_arg);
      add_extra_node_spec_array (current, "nodes_manuals", nodes_manuals);


      /* Also set 'normalized' here.  The normalized labels are actually 
         the keys of "labels_information($parser)". */

      /*Check that the node name doesn't have a filename element for 
        referring to an external manual (_check_internal_node), and that it 
        is not empty (_check_empty_node).  */
      //check_node_label ();

      add_extra_key_contents (current, "node_content",
                              nodes_manuals[0]->node_content);

      /* This sets 'node_content' and 'normalized' on the node, among
         other things (which were already set in parse_node_manual).
         Are we normalizing the name twice? */
      register_label (current, nodes_manuals[0]->node_content);

      current_node = current;
    }
  else if (current->cmd == CM_listoffloats) /* 3248 */
    {
    }
  else
    {
      ELEMENT *misc_args;

      misc_args = trim_spaces_comment_from_content 
        (last_args_child(current));

      add_extra_key_misc_args (current, "misc_args", misc_args);

      /* All the other "line" commands" */
      // 3273 - warning about missing argument

      /* Index commands */
      if (command_flags(current) & CF_index_entry_command)
        {
          /* TODO: Trim space elements from contents.  Note we aren't
             using the misc_args variable yet, because we have not
             got a way to serialize a pointer from the index information
             to a detached extra key that is not part of the main tree. */
          ELEMENT *contents;
          contents = last_args_child(current);

          // 3274
          enter_index_entry (current->cmd, current->cmd, current,
                             contents);
          current->type = ET_index_entry_command;
        }
    }

  current = current->parent; /* 3285 */
  if (end_command) /* Set above */
    {
      /* more processing of @end */
      ELEMENT *end_elt;

      debug ("END COMMAND %s", end_command);

      /* Reparent the "@end" element to be a child of the block element. */
      end_elt = pop_element_from_contents (current);

      /* 3289 If not a conditional */
      if (command_data(end_id).data != BLOCK_conditional)
        {
          ELEMENT *closed_command;
          /* This closes tree elements (e.g. paragraphs) until we reach
             end_command.  It can print an error if another block command
             is found first. */
          current = close_commands (current, end_id,
                          &closed_command, 0); /* 3292 */
          if (!closed_command)
            abort (); // 3335

          close_command_cleanup (closed_command);
          // 3301 INLINE_INSERTCOPYING
          add_to_element_contents (closed_command, end_elt); // 3321
          // 3324 ET_menu_comment
          if (close_preformatted_command (end_id))
            current = begin_preformatted (current);
        }
    } /* 3340 */
  else
    {
      if (close_preformatted_command (cmd_id))
        current = begin_preformatted (current);
    }

  /* 3346 included file */

  /* 3350 */
  if (cmd_id == CM_setfilename && (current_node || current_section))
    {
      /* warning */
      abort ();
    }
  /* 3355 columnfractions */
  else if (cmd_id == CM_columnfractions)
    {
      ELEMENT *before_item;
      KEY_PAIR *misc_args;

      /* Check if in multitable. */
      if (!current->parent || current->parent->cmd != CM_multitable)
        {
          abort ();
        }

      // pop and check context stack

      current = current->parent;

      if (misc_args = lookup_extra_key (misc_cmd, "misc_args"))
        {
          add_extra_key_misc_args (current, "columnfractions", 
                                   misc_args->value);
        }

      before_item = new_element (ET_before_item);
      add_to_element_contents (current, before_item);
      current = before_item;
    }
  else if (command_data(cmd_id).flags & CF_root) /* 3380 */
    {
      current = last_contents_child (current);
      
      /* 3383 Destroy all contents (why do we do this?) */
      while (last_contents_child (current))
        destroy_element (pop_element_from_contents (current));

      /* Set 'associated_section' extra key for a node. */
      if (cmd_id != CM_node && cmd_id != CM_part)
        {
          if (current_node)
            {
              if (!lookup_extra_key (current_node, "associated_section"))
                {
                  add_extra_key_element
                    (current_node, "associated_section", current);
                  add_extra_key_element
                    (current, "associated_node", current_node);
                }
            }

          // "current parts" - 3394

          current_section = current;
        }
    } /* 3416 */

  return current;
}

/* 2610 */
/* Actions to be taken when a whole line of input has been processed */
ELEMENT *
end_line (ELEMENT *current)
{
  // 2621
  /* If empty line, start a new paragraph. */
  if (last_contents_child (current)
      && last_contents_child (current)->type == ET_empty_line)
    {
      debug ("END EMPTY LINE");
      if (current->type == ET_paragraph) /* 2625 */
        {
          ELEMENT *e;
          /* Remove empty_line element. */
          e = pop_element_from_contents (current);

          current = end_paragraph (current);

          /* Add empty_line to higher-level element. */
          add_to_element_contents (current, e);
        }
      //else if () // in menu_entry_description
      else if (!in_no_paragraph_contexts (current_context ()))
        {
          current = end_paragraph (current);
        }
    }

  // 2667
  /* The end of the line of a menu. */
  else if (current->type == ET_menu_entry_name
           || current->type == ET_menu_entry_node)
    {
      ELEMENT *end_comment;
      int empty_menu_entry_node = 0;

      if (current->type == ET_menu_entry_node)
        {
          ELEMENT *last = last_contents_child (current);

          if (current->contents.number > 0
              && (last->cmd == CM_c || last->cmd == CM_comment))
            {
              end_comment = pop_element_from_contents (current);
            }

          /* If contents empty or is all whitespace. */
          if (current->contents.number == 0
              || (current->contents.number == 1
                  && last->text.end > 0
                  && !last->text.text[strspn (last->text.text, 
                                              whitespace_chars)]))
            {
              empty_menu_entry_node = 1;
              if (end_comment)
                add_to_element_contents (current, end_comment);
            }
        }

      // 2689
      /* Abort the menu entry if there is no destination node given. */
      if (empty_menu_entry_node || current->type == ET_menu_entry_name)
        {
        }
      else // 2768
        {
          debug ("MENU ENTRY END LINE");
          current = current->parent;
          current = enter_menu_entry_node (current);
          if (end_comment)
            add_to_element_contents (current, end_comment);
        }
    }

  /* Is it a def line 2778 */
  else if (current->parent && current->parent->type == ET_def_line)
    {
      enum element_type def_command;

      if (pop_context () != ct_def)
        {
          abort ();
        }

#if 0
      /* current->parent is a ET_def_line, and current->parent->parent
         the def command. */
      def_command = current->parent->parent->cmd;
      // strip a trailing x
      parse_def (def_command, current->contents);
#endif

      current = current->parent->parent;
      current = begin_preformatted (current);

    }

  // 2872
  /* End of a line starting a block. */
  else if (current->type == ET_block_line_arg)
    {
      current = end_line_starting_block (current);
    }

  /* after an "@end verbatim" 3090 */
  else if (current->contents.number
           && last_contents_child(current)->type == ET_empty_line_after_command
    /* The Perl version gets the command with the 'command' key in 'extra'. */
           && contents_child_by_index(current, -2)
           && contents_child_by_index(current, -2)->cmd == CM_verbatim)
    {
      // I don't know what this means.  raw command is @html etc.?
      /*
     if we are after a @end verbatim, we must restart a preformatted if needed,
     since there is no @end command explicitly associated to raw commands
     it won't be done elsewhere.
      */

      current = begin_preformatted (current);
    }
  /* if it's a misc line arg 3100 */
  else if (current->type == ET_misc_line_arg)
    {
      current = end_line_misc_line (current);
    }


  // something to do with an empty line /* 3419 */

  //if () /* 'line' or 'def' at top of "context stack" */
    {
      /* Recurse. */
    }
  return current;
} /* end_line 3487 */
