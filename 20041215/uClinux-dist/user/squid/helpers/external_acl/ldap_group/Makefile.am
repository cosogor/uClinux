#
#  Makefile for the Squid LDAP authentication helper
#
#  $Id: Makefile.am,v 1.1.6.4 2002/12/12 03:15:07 squidadm Exp $
#
#  Uncomment and customize the following to suit your needs:
#

libexec_PROGRAMS 	= squid_ldap_group
man_MANS 		= squid_ldap_group.8
EXTRA_DIST		= squid_ldap_group.8
squid_ldap_group_SOURCES	= squid_ldap_group.c

LDADD = -lldap -llber $(XTRA_LIBS)
