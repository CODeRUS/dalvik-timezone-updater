#include <QtQuick>
#include <sailfishapp.h>

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    app->setApplicationDisplayName("Alien Dalvik Timezone Updater");
    app->setApplicationName("Alien Dalvik Timezone Updater");

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->setTitle("Alien Dalvik Timezone Updater");

    view->setSource(SailfishApp::pathTo("qml/main.qml"));
    view->showFullScreen();

    return app->exec();
}

