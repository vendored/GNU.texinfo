#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "../tree_types.h"
#include "../tree.h"
#include "../api.h"

MODULE = Parsetexi		PACKAGE = Parsetexi		

TYPEMAP: <<END
ELEMENT *   T_UV
END

char *
dump_tree_to_string_1 ()

char *
dump_tree_to_string_2 ()

char *
dump_tree_to_string_3 ()

char *dump_root_element_1 ()

char *dump_root_element_2 ()

void
parse_file(filename)
        char * filename

ELEMENT *
get_root()

char *
element_type_name(e)
        ELEMENT *e

int
num_contents_children(e)
        ELEMENT *e

int
num_args_children (e)
        ELEMENT *e

ELEMENT *
contents_child_by_index (e, index)
        ELEMENT *e
        int index