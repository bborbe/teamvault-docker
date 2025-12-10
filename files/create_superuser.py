#!/usr/bin/env python3
"""Create or update Django superuser from environment variables."""
import os
import sys

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'teamvault.settings')

import django
django.setup()

from django.contrib.auth import get_user_model

def main():
    username = os.environ.get('SUPERUSER_NAME')
    password = os.environ.get('SUPERUSER_PASSWORD')
    email = os.environ.get('SUPERUSER_EMAIL', 'admin@example.com')

    if not username or not password:
        print('SUPERUSER_NAME and SUPERUSER_PASSWORD environment variables required')
        sys.exit(1)

    User = get_user_model()
    user, created = User.objects.get_or_create(
        username=username,
        defaults={
            'email': email,
            'is_staff': True,
            'is_superuser': True
        }
    )

    user.set_password(password)
    user.is_staff = True
    user.is_superuser = True
    user.save()

    if created:
        print(f'Superuser "{username}" created successfully')
    else:
        print(f'Superuser "{username}" password updated')

if __name__ == '__main__':
    main()
