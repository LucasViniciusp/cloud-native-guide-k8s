# **CLOUD NATIVE**

This project uses the mkdocs library [`mkdocs-material`](https://squidfunk.github.io/mkdocs-material/)
This documentation intends to reinforce a set of practices to improve the software development process.
<hr>

## Run using docker

```sh
docker run --rm -p 8000:80 lukeinstruct/cloud-native:latest
```

## For local development

### Using docker-compose

```bash
docker-compose up -d
```

### Install using virtualenv

Dependencies:

- install virtualenv library
    1. `pip install virtualenv`

1. Create a virtual enviroment
    - `python3 -m venv venv

2. Activate the virtual environment
    - ***Mac OS / Linux***
        - source `venv/bin/activate
    - ***Windows***
        - mypthon\Scripts\activate

    - ***to get out, simply type `deactivate`***

3. Install mkdocs-material dependency
    - `pip install mkdocs-material`

<hr>

## Previewing as you write

MkDocs includes a live preview server, The server will automatically rebuild the site upon saving

```bash
mkdocs serve
```

When you're finished editing, you can build a static site from your Markdown files with:

```bash
mkdocs build
```
