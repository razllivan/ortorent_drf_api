"""
Test custom Django management commands
"""

from unittest.mock import patch
from django.db import connection
from psycopg2 import OperationalError as Psycopg2Error

from django.core.management import call_command
from django.db.utils import OperationalError
from django.test import SimpleTestCase


@patch.object(connection, 'ensure_connection')
class CommandTests(SimpleTestCase):
    """Test commands"""

    def test_wait_for_db_ready(self, mocked_ensure_connection):
        """Test waiting for database if database ready"""
        mocked_ensure_connection.return_value = True

        call_command('wait_for_db')

        mocked_ensure_connection.assert_called_once()

    @patch('time.sleep')
    def test_wait_for_db_delay(self, mocked_sleep, mocked_ensure_connection):
        """Test waiting for database when getting OperationalError"""
        exceptions = [Psycopg2Error] * 2 + \
                     [OperationalError] * 3 + \
                     [True]
        mocked_ensure_connection.side_effect = exceptions

        call_command('wait_for_db')

        self.assertEqual(mocked_ensure_connection.call_count, len(exceptions))
