#ifndef DBUSLISTENER_H
#define DBUSLISTENER_H

#include <QObject>

#include <QtDBus>

class DBusListener : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.coderus.dalviktimezoneupdater")
public:
    explicit DBusListener(QObject *parent = 0);

public slots:
    void startService();

    Q_SCRIPTABLE bool updateTimezones();

};

#endif // DBUSLISTENER_H
