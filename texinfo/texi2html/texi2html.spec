Name: texi2html
Version: 1.77
Release: 1
Epoch: 0
License: GPL
Group: Applications/Text
Summary: A highly customizable texinfo to HTML and other formats translator
Source: http://savannah.nongnu.org/download/texi2html/%{name}-%{version}.tar.gz
URL: http://www.nongnu.org/texi2html/

Requires: perl >= 5.004
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info
# uncomment this if you want to build a relocatable package
#Prefix: %{_prefix}
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)


%description
The basic purpose of texi2html is to convert Texinfo documents into HTML, 
and other formats.  Configuration files written in perl provide fine degree 
of control over the final output, allowing most every aspect of the final 
output not specified in the Texinfo input file to be specified.  

%prep
%setup -q

%build
%configure
make clean
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT 
#%find_lang %{name}

rm -f $RPM_BUILD_ROOT%{_infodir}/dir

%clean
rm -rf $RPM_BUILD_ROOT

%post
/sbin/install-info %{_infodir}/%{name}.info %{_infodir}/dir || :

%preun
if [ $1 = 0 ]; then
  /sbin/install-info --delete %{_infodir}/%{name}.info %{_infodir}/dir || :
fi

%files
%defattr(-,root,root)
%doc AUTHORS NEWS README ChangeLog %{name}.init
%{_bindir}/%{name}
%{_datadir}/texinfo/html/%{name}.html
%{_mandir}/man*/%{name}*
%{_infodir}/%{name}.info*
%dir %{_datadir}/%{name}
%{_datadir}/%{name}/*.init
%dir %{_datadir}/%{name}/i18n/
%{_datadir}/%{name}/i18n/*
%dir %{_datadir}/%{name}/images/
%{_datadir}/%{name}/images/*

%changelog
* Mon Mar 23 2004 Patrice Dumas <pertusus@free.fr> 0:1.69-0.fdr.1
- Initial build.
