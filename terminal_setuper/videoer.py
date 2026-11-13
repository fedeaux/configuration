import iterm2, sys, asyncio, os, inspect

currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0,parentdir)

from braindamage import BraindamageTerminalSetuper

class VideoerTerminalSetuper(BraindamageTerminalSetuper):
    def __init__(self):
        self.app = { 'path': os.environ['TERMINAL_SETUPER_VIDEOER_PATH'] }


    async def setup(self):
        self.current_app = self.app

        session = self.window.current_tab.current_session

        await self.run_in_session(session, [
            'docker compose up',
            'mgrok'
        ])

        tabs = [
            [
                'rails s -b 0.0.0.0',
                './bin/dev',
                'bundle exec sidekiq'
            ],
            [
                'rails console',
                '',
                'clear'
            ]
        ]

        for commands in tabs:
             await self.run_in_new_tab(commands)

async def main(connection):
    await VideoerTerminalSetuper().start(connection)

iterm2.run_until_complete(main, True)
