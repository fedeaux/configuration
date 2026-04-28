import sys, asyncio, os, inspect, iterm2

currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0,parentdir)

from terminal_setuper import TerminalSetuper

class WordableTerminalSetuper(TerminalSetuper):
    def __init__(self):
        self.app = { 'path': os.environ['TERMINAL_SETUPER_WORDABLE_PATH'] }

    async def start(self, connection):
        app = await iterm2.async_get_app(connection)
        self.window = app.current_window

        await self.setup()

    async def setup(self):
        self.current_app = self.app

        session = self.window.current_tab.current_session

        await self.run_in_session(session, [
            'docker compose up',
            './bin/webpack-dev-server',
            'wgrok'
        ])

        tabs = [
            [
                'rails server',
                'bundle exec sidekiq'
            ],
            [
                'rails console',
                'clear'
            ]
        ]

        for commands in tabs:
            await self.run_in_new_tab(commands)

async def main(connection):
    await WordableTerminalSetuper().start(connection)

iterm2.run_until_complete(main, True)
