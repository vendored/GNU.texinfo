use vars qw(%result_texts %result_trees %result_errors);

$result_trees{'bad_line'} = {
  'contents' => [
    {
      'parent' => {},
      'text' => '
',
      'type' => 'normal_line'
    },
    {
      'args' => [
        {
          'contents' => [
            {
              'parent' => {},
              'text' => 'garbage_on_line =cmd garbage
'
            }
          ],
          'parent' => {},
          'type' => 'misc_line_arg'
        }
      ],
      'cmdname' => 'alias',
      'parent' => {},
      'special' => {
        'misc_args' => [
          'garbage_on_line',
          'cmd'
        ]
      }
    },
    {
      'parent' => {},
      'text' => '
',
      'type' => 'normal_line'
    },
    {
      'args' => [
        {
          'contents' => [
            {
              'parent' => {},
              'text' => 'garbage_on_line =cmd '
            },
            {
              'args' => [
                {
                  'contents' => [
                    {
                      'parent' => {},
                      'text' => 'in code'
                    }
                  ],
                  'parent' => {},
                  'type' => 'brace_command_arg'
                }
              ],
              'cmdname' => 'code',
              'parent' => {},
              'remaining_args' => 0
            },
            {
              'parent' => {},
              'text' => '
'
            }
          ],
          'parent' => {},
          'type' => 'misc_line_arg'
        }
      ],
      'cmdname' => 'alias',
      'parent' => {},
      'special' => {
        'misc_args' => [
          'garbage_on_line',
          'cmd'
        ]
      }
    }
  ]
};
$result_trees{'bad_line'}{'contents'}[0]{'parent'} = $result_trees{'bad_line'};
$result_trees{'bad_line'}{'contents'}[1]{'args'}[0]{'contents'}[0]{'parent'} = $result_trees{'bad_line'}{'contents'}[1]{'args'}[0];
$result_trees{'bad_line'}{'contents'}[1]{'args'}[0]{'parent'} = $result_trees{'bad_line'}{'contents'}[1];
$result_trees{'bad_line'}{'contents'}[1]{'parent'} = $result_trees{'bad_line'};
$result_trees{'bad_line'}{'contents'}[2]{'parent'} = $result_trees{'bad_line'};
$result_trees{'bad_line'}{'contents'}[3]{'args'}[0]{'contents'}[0]{'parent'} = $result_trees{'bad_line'}{'contents'}[3]{'args'}[0];
$result_trees{'bad_line'}{'contents'}[3]{'args'}[0]{'contents'}[1]{'args'}[0]{'contents'}[0]{'parent'} = $result_trees{'bad_line'}{'contents'}[3]{'args'}[0]{'contents'}[1]{'args'}[0];
$result_trees{'bad_line'}{'contents'}[3]{'args'}[0]{'contents'}[1]{'args'}[0]{'parent'} = $result_trees{'bad_line'}{'contents'}[3]{'args'}[0]{'contents'}[1];
$result_trees{'bad_line'}{'contents'}[3]{'args'}[0]{'contents'}[1]{'parent'} = $result_trees{'bad_line'}{'contents'}[3]{'args'}[0];
$result_trees{'bad_line'}{'contents'}[3]{'args'}[0]{'contents'}[2]{'parent'} = $result_trees{'bad_line'}{'contents'}[3]{'args'}[0];
$result_trees{'bad_line'}{'contents'}[3]{'args'}[0]{'parent'} = $result_trees{'bad_line'}{'contents'}[3];
$result_trees{'bad_line'}{'contents'}[3]{'parent'} = $result_trees{'bad_line'};

$result_texts{'bad_line'} = '
@alias garbage_on_line =cmd garbage

@alias garbage_on_line =cmd @code{in code}
';

$result_errors{'bad_line'} = [
  {
    'error_line' => ':4: Bad argument to @alias
',
    'file_name' => '',
    'line_nr' => 4,
    'macro' => '',
    'text' => 'Bad argument to @alias',
    'type' => 'error'
  }
];


