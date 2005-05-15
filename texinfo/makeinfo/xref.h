/* xref.h -- declarations for the cross references.
   $Id: xref.h,v 1.2 2005-05-15 00:00:08 karl Exp $

   Copyright (C) 2004 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */

#ifndef XREF_H
#define XREF_H

enum reftype
{
  menu_reference, followed_reference
};

extern char *get_xref_token (int expand);

#endif /* not XREF_H */
