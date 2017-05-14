#===================================================================
# RPM Spec file
#===================================================================

%define _unpackaged_files_terminate_build 0
%define packageName demo
%define source_version 1.0
%define demo_version 1.0
%define subsys_version 1.0
%define release 1
%define kernel_version %(uname -r)

# Introduction section
Summary: build app rpm demo 
Name: %{packageName}
Version: %{demo_version}
Release: %{release}
Source: demo-%{source_version}.tar
BuildRoot: %{_topdir}/BUILDROOT/%{packageName}-%{source_version}-%{release}.x86_64
Group: Application/Internet
Vendor: xilingxue
License: GPL
Prefix: /opt
Provides: %{packageName}
%description
The demo application is used for showing how to build the RPM

%package subsys
Summary: kernel subsystem for demo application
Group: System Environment/Kernel
Version: %{subsys_version}
Provides: %{packageName}-subsys
Requires: %{packageName}
%description subsys
Provides subsystem for demo


# Prepare section before building
# Extract source code and create directory named by tarball name
%prep
mkdir -p %{buildroot}
%setup -qc

# Building section
%build
make

# Install section
%install
make install DESTDIR=%{buildroot}

# Script run after installation
%post
/sbin/ldconfig

# Script run after the package is uninstalled
%postun

%post subsys
depmod -a

%preun subsys
echo 'Clean files pre-uninstall...'

%files
/usr/local/sbin/demo
/usr/local/lib/libfoo.so

%files subsys
/lib/modules/%{kernel_version}/extra/*.ko

%clean
rm -fr %{buildroot}
