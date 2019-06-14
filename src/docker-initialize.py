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
        DATABASE_URL = self.env.get('DATABASE_URL', None)

        if not DATABASE_URL:
            return

        config = ""
        with open(self.zope_conf, "r") as cfile:
            config = cfile.read()

        config = config.replace(
            'DB-host', DATABASE_URL.split('@')[1].split(':')[0]
        ).replace(
            'DB-name', DATABASE_URL.split('/')[-1]
        ).replace(
            'DB-user', DATABASE_URL.split('//')[1].split(':')[0]
        ).replace(
            'DB-password', DATABASE_URL.split('//')[1].split(':')[1].split('@')[0]
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