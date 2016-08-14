Name:       dalvik-timezone-updater

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    Dalvik Timezone Updater
Version:    1.0.0
Release:    2016f
Group:      Qt/Qt
License:    WTFPL
URL:        https://openrepos.net/content/coderus/dalvik-timezone-updater
Source0:    %{name}-%{version}.tar.bz2
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

Summary: Alien Dalvik timezone data updater

%description
Alien Dalvik timezone data updater

%prep
%setup -q -n %{name}-%{version}

%build

%qtc_qmake5  \
    VERSION=%{version}

%qtc_make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%qmake5_install

%pre
if /sbin/pidof dalvik-timezone-updater-service > /dev/null; then
killall dalvik-timezone-updater-service || true
fi

%preun
if /sbin/pidof dalvik-timezone-updater-service > /dev/null; then
killall dalvik-timezone-updater-service || true
fi

%files
%attr(4755, root, root) %{_bindir}/dalvik-timezone-updater-service
%attr(0755, root, root) %{_bindir}/dalvik-timezone-updater
%defattr(664,root,root,-)
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/86x86/apps/%{name}.png
%{_datadir}/icons/hicolor/108x108/apps/%{name}.png
%{_datadir}/icons/hicolor/128x128/apps/%{name}.png
%{_datadir}/icons/hicolor/256x256/apps/%{name}.png
%{_datadir}/dalvik-timezone-updater
%{_datadir}/dbus-1/services/org.coderus.dalviktimezoneupdater.service
