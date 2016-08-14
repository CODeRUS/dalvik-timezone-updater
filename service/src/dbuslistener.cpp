#include "dbuslistener.h"
#include <QCoreApplication>
#include <QTimer>

DBusListener::DBusListener(QObject *parent) :
    QObject(parent)
{
}

void DBusListener::startService()
{
    qDebug("Starting service...");

    bool dbusServiceOk = QDBusConnection::sessionBus().registerService("org.coderus.dalviktimezoneupdater");
    qDebug() << "DBus service" << (dbusServiceOk ? "registered" : "error!");

    if (dbusServiceOk) {
        bool dbusObjectOk = QDBusConnection::sessionBus().registerObject("/", this, QDBusConnection::ExportScriptableSlots);
        qDebug() << "DBus object" << (dbusObjectOk ? "registered" : "error!");

        if (dbusObjectOk) {
            qDebug() << "service started!";
        } else {
            qApp->quit();
        }
    } else {
        qApp->quit();
    }

}

bool DBusListener::updateTimezones()
{
    QString newtzdata("/usr/share/dalvik-timezone-updater/tzdata/tzdata");
    QString newzoneinfodat("/usr/share/dalvik-timezone-updater/tzdata/zoneinfo.dat");
    QString newzoneinfoidx("/usr/share/dalvik-timezone-updater/tzdata/zoneinfo.idx");
    QString newzoneinfoversion("/usr/share/dalvik-timezone-updater/tzdata/zoneinfo.version");

    QString tzdata("/opt/alien/system/usr/share/zoneinfo/tzdata");
    QString zoneinfodat("/opt/alien/system/usr/share/zoneinfo/zoneinfo.dat");
    QString zoneinfoidx("/opt/alien/system/usr/share/zoneinfo/zoneinfo.idx");
    QString zoneinfoversion("/opt/alien/system/usr/share/zoneinfo/zoneinfo.version");
    if (QFile(tzdata).exists()) {
        QFile::remove(tzdata);
        QFile::copy(newtzdata, tzdata);
    } else {
        QFile::remove(zoneinfodat);
        QFile::copy(newzoneinfodat, zoneinfodat);
        QFile::remove(zoneinfoidx);
        QFile::copy(newzoneinfoidx, zoneinfoidx);
        QFile::remove(zoneinfoversion);
        QFile::copy(newzoneinfoversion, zoneinfoversion);
    }

    QTimer::singleShot(100, qApp, SLOT(quit()));
    return true;
}
