# Teamvault

## Sources

https://github.com/trehn/teamvault

## Run Postgres

```
docker run \
-p 5432:5432 \
-e POSTGRES_PASSWORD='jXDtEhnQlEJjrdT8' \
-e PGDATA='/var/lib/postgresql/data/pgdata' \
-e POSTGRES_USER='teamvault' \
-e POSTGRES_DB='teamvault' \
postgres:9.6
```

## Run Teamvault

```
docker run \
-p 8000:8000 \
-e BASE_URL='teamvault.benjamin-borbe.de' \
-e SECRET_KEY='Lk0nKXc2eE55MUg2KHFecUVHW1BzSFc5Kl0jPz1HQ0JLejcpVHJ1UjdtJnJAbyxkfSQ=' \
-e FERNET_KEY='VE_jV0JFmi8r0SqT_fJRHwDatSqSWa9xz_vi3fbahFs=' \
-e SALT='YFp5c2Y/KWZaeGVgaS47NSNRKSNoOXpOZkxlMDp1ZXtsWX09OmEkK2tuPS1pSk46U3k=' \
-e DEBUG='enabled' \
-e DATABASE_HOST='teamvault-postgres' \
-e DATABASE_NAME='teamvault' \
-e DATABASE_USER='teamvault' \
-e DATABASE_PASSWORD='jXDtEhnQlEJjrdT8' \
-e DATABASE_PORT='5432' \
bborbe/teamvault
```

## Create superuser

```
docker run -ti \
-e BASE_URL='teamvault.benjamin-borbe.de' \
-e SECRET_KEY='Lk0nKXc2eE55MUg2KHFecUVHW1BzSFc5Kl0jPz1HQ0JLejcpVHJ1UjdtJnJAbyxkfSQ=' \
-e FERNET_KEY='VE_jV0JFmi8r0SqT_fJRHwDatSqSWa9xz_vi3fbahFs=' \
-e SALT='YFp5c2Y/KWZaeGVgaS47NSNRKSNoOXpOZkxlMDp1ZXtsWX09OmEkK2tuPS1pSk46U3k=' \
-e DEBUG='enabled' \
-e DATABASE_HOST='teamvault-postgres' \
-e DATABASE_NAME='teamvault' \
-e DATABASE_USER='teamvault' \
-e DATABASE_PASSWORD='jXDtEhnQlEJjrdT8' \
-e DATABASE_PORT='5432' \
bborbe/teamvault \
teamvault plumbing createsuperuser
```

## Ready to run
 
`open http://teamvault-address:8000` 

## Copyright and license

    Copyright (c) 2016, Benjamin Borbe <bborbe@rocketnews.de>
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are
    met:
    
       * Redistributions of source code must retain the above copyright
         notice, this list of conditions and the following disclaimer.
       * Redistributions in binary form must reproduce the above
         copyright notice, this list of conditions and the following
         disclaimer in the documentation and/or other materials provided
         with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
    A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
    OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
