use vars qw(%result_texis %result_texts %result_trees %result_errors 
   %result_indices %result_sectioning %result_nodes %result_menus
   %result_floats %result_converted %result_converted_errors 
   %result_elements %result_directions_text);

use utf8;

$result_trees{'defx_after_empty_line'} = {
  'contents' => [
    {
      'cmdname' => 'deffn',
      'contents' => [
        {
          'args' => [
            {
              'contents' => [
                {
                  'parent' => {},
                  'text' => ' ',
                  'type' => 'empty_spaces_after_command'
                },
                {
                  'text' => 'fset'
                },
                {
                  'text' => ' ',
                  'type' => 'spaces'
                },
                {
                  'args' => [
                    {
                      'contents' => [
                        {
                          'parent' => {},
                          'text' => 'i'
                        }
                      ],
                      'parent' => {},
                      'type' => 'brace_command_arg'
                    }
                  ],
                  'cmdname' => 'var',
                  'contents' => [],
                  'line_nr' => {
                    'file_name' => '',
                    'line_nr' => 1,
                    'macro' => ''
                  },
                  'parent' => {}
                },
                {
                  'text' => ' ',
                  'type' => 'spaces'
                },
                {
                  'text' => 'a'
                },
                {
                  'text' => ' ',
                  'type' => 'spaces'
                },
                {
                  'text' => 'g'
                },
                {
                  'text' => '
',
                  'type' => 'spaces_at_end'
                }
              ],
              'parent' => {},
              'type' => 'block_line_arg'
            }
          ],
          'extra' => {
            'def_args' => [
              [
                'category',
                {}
              ],
              [
                'spaces',
                {}
              ],
              [
                'name',
                {}
              ],
              [
                'spaces',
                {}
              ],
              [
                'arg',
                {}
              ],
              [
                'spaces',
                {}
              ],
              [
                'arg',
                {}
              ],
              [
                'spaces',
                {}
              ]
            ],
            'def_command' => 'deffn',
            'def_parsed_hash' => {
              'category' => {},
              'name' => {}
            },
            'index_entry' => {
              'command' => {},
              'content' => [
                {}
              ],
              'content_normalized' => [
                {}
              ],
              'in_code' => 1,
              'index_at_command' => 'deffn',
              'index_name' => 'fn',
              'index_type_command' => 'deffn',
              'key' => 'i',
              'number' => 1
            },
            'original_def_cmdname' => 'deffn'
          },
          'line_nr' => {},
          'parent' => {},
          'type' => 'def_line'
        },
        {
          'contents' => [
            {
              'parent' => {},
              'text' => '
',
              'type' => 'empty_line'
            }
          ],
          'parent' => {},
          'type' => 'inter_def_item'
        },
        {
          'args' => [
            {
              'contents' => [
                {
                  'parent' => {},
                  'text' => ' ',
                  'type' => 'empty_spaces_after_command'
                },
                {
                  'contents' => [
                    {
                      'parent' => {},
                      'text' => 'truc'
                    }
                  ],
                  'line_nr' => {
                    'file_name' => '',
                    'line_nr' => 3,
                    'macro' => ''
                  },
                  'parent' => {},
                  'type' => 'bracketed_def_content'
                },
                {
                  'text' => ' ',
                  'type' => 'spaces'
                },
                {
                  'text' => 'bidulr'
                },
                {
                  'text' => ' ',
                  'type' => 'spaces'
                },
                {
                  'text' => 'machin...'
                },
                {
                  'text' => '
',
                  'type' => 'spaces_at_end'
                }
              ],
              'parent' => {},
              'type' => 'misc_line_arg'
            }
          ],
          'cmdname' => 'deffnx',
          'extra' => {
            'def_args' => [
              [
                'category',
                {}
              ],
              [
                'spaces',
                {}
              ],
              [
                'name',
                {}
              ],
              [
                'spaces',
                {}
              ],
              [
                'arg',
                {}
              ],
              [
                'spaces',
                {}
              ]
            ],
            'def_command' => 'deffn',
            'def_parsed_hash' => {
              'category' => {},
              'name' => {}
            },
            'index_entry' => {
              'command' => {},
              'content' => [
                {}
              ],
              'content_normalized' => [
                {}
              ],
              'in_code' => 1,
              'index_at_command' => 'deffnx',
              'index_name' => 'fn',
              'index_type_command' => 'deffn',
              'key' => 'bidulr',
              'number' => 2
            },
            'original_def_cmdname' => 'deffnx',
            'spaces_after_command' => {}
          },
          'line_nr' => {},
          'parent' => {},
          'type' => 'def_line'
        },
        {
          'args' => [
            {
              'contents' => [
                {
                  'parent' => {},
                  'text' => ' ',
                  'type' => 'empty_spaces_after_command'
                },
                {
                  'parent' => {},
                  'text' => 'deffn'
                }
              ],
              'parent' => {},
              'type' => 'misc_line_arg'
            }
          ],
          'cmdname' => 'end',
          'extra' => {
            'command_argument' => 'deffn',
            'spaces_after_command' => {},
            'text_arg' => 'deffn'
          },
          'line_nr' => {
            'file_name' => '',
            'line_nr' => 4,
            'macro' => ''
          },
          'parent' => {}
        }
      ],
      'extra' => {
        'end_command' => {},
        'spaces_after_command' => {}
      },
      'line_nr' => {},
      'parent' => {}
    }
  ],
  'type' => 'text_root'
};
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[0]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[3]{'args'}[0]{'contents'}[0]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[3]{'args'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[3]{'args'}[0]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[3];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[3]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'extra'}{'def_args'}[0][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[1];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'extra'}{'def_args'}[1][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[2];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'extra'}{'def_args'}[2][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[3];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'extra'}{'def_args'}[3][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[4];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'extra'}{'def_args'}[4][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[5];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'extra'}{'def_args'}[5][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[6];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'extra'}{'def_args'}[6][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[7];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'extra'}{'def_args'}[7][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[8];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'extra'}{'def_parsed_hash'}{'category'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[1];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'extra'}{'def_parsed_hash'}{'name'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[3];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'extra'}{'index_entry'}{'command'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'extra'}{'index_entry'}{'content'}[0] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[3];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'extra'}{'index_entry'}{'content_normalized'}[0] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[3];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'line_nr'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[3]{'line_nr'};
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[1]{'contents'}[0]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[1];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[1]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[0]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[1]{'contents'}[0]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[1];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[1]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'extra'}{'def_args'}[0][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[1];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'extra'}{'def_args'}[1][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[2];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'extra'}{'def_args'}[2][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[3];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'extra'}{'def_args'}[3][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[4];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'extra'}{'def_args'}[4][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[5];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'extra'}{'def_args'}[5][1] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[6];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'extra'}{'def_parsed_hash'}{'category'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[1];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'extra'}{'def_parsed_hash'}{'name'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[3];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'extra'}{'index_entry'}{'command'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'extra'}{'index_entry'}{'content'}[0] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[3];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'extra'}{'index_entry'}{'content_normalized'}[0] = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[3];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'extra'}{'spaces_after_command'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'line_nr'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'args'}[0]{'contents'}[1]{'line_nr'};
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[2]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[3]{'args'}[0]{'contents'}[0]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[3]{'args'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[3]{'args'}[0]{'contents'}[1]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[3]{'args'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[3]{'args'}[0]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[3];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[3]{'extra'}{'spaces_after_command'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[3]{'args'}[0]{'contents'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[3]{'parent'} = $result_trees{'defx_after_empty_line'}{'contents'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'extra'}{'end_command'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[3];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'extra'}{'spaces_after_command'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[0];
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'line_nr'} = $result_trees{'defx_after_empty_line'}{'contents'}[0]{'contents'}[0]{'args'}[0]{'contents'}[3]{'line_nr'};
$result_trees{'defx_after_empty_line'}{'contents'}[0]{'parent'} = $result_trees{'defx_after_empty_line'};

$result_texis{'defx_after_empty_line'} = '@deffn fset @var{i} a g

@deffnx {truc} bidulr machin...
@end deffn';


$result_texts{'defx_after_empty_line'} = 'fset: i a g

truc: bidulr machin...
';

$result_errors{'defx_after_empty_line'} = [
  {
    'error_line' => ':1: warning: entry for index `fn\' outside of any node
',
    'file_name' => '',
    'line_nr' => 1,
    'macro' => '',
    'text' => 'entry for index `fn\' outside of any node',
    'type' => 'warning'
  },
  {
    'error_line' => ':3: warning: entry for index `fn\' outside of any node
',
    'file_name' => '',
    'line_nr' => 3,
    'macro' => '',
    'text' => 'entry for index `fn\' outside of any node',
    'type' => 'warning'
  }
];



$result_converted{'plaintext'}->{'defx_after_empty_line'} = ' -- fset: I a g

 -- truc: bidulr machin...
';

1;
