#!/plone/instance/bin/python
"""Configure RelStorage."""
import os


class Environment(object):
    """Configure container via environment variables."""

    def __init__(self, env=os.environ,
                 zope_conf='/plone/instance/parts/instance/etc/zope.conf'):
        """Initialize the environment."""
        self.env = env
        self.zope_conf = zope_conf

    def relstorage(self):
        """Relstorage configuration."""
        RELSTORAGE_HOST = self.env.get('RELSTORAGE_HOST', None)
        RELSTORAGE_DB = self.env.get('RELSTORAGE_DB', None)
        RELSTORAGE_USER = self.env.get('RELSTORAGE_USER', None)
        RELSTORAGE_PASS = self.env.get('RELSTORAGE_PASS', None)

        if not RELSTORAGE_HOST:
            return

        config = ""
        with open(self.zope_conf, "r") as cfile:
            config = cfile.read()

        config = config.replace(
            'DB-host', RELSTORAGE_HOST
        ).replace(
            'DB-name', RELSTORAGE_DB
        ).replace(
            'DB-user', RELSTORAGE_USER
        ).replace(
            'DB-password', RELSTORAGE_PASS
        )

        with open(self.zope_conf, "w") as cfile:
            cfile.write(config)

    def setup(self, **kwargs):
        """Setup environment."""
        self.relstorage()

    __call__ = setup


def initialize():
    """Configure Plone instance using RelStorage."""
    environment = Environment()
    environment.setup()


if __name__ == "__main__":
    initialize()