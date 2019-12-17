import os
import re
import click
import requests
import zipfile

__repo__ = "cedricgrothues/httprouter"


@click.group()
def application():
    """
    The home-automation command line interface for setting up, ugrading and maintaining your home hub. If you run into any issues or need help setting up a hub, visit https://github.com/cedricgrothues/home-automation
    """
    pass


@application.command()
@click.argument('address')
def setup(address):
    """Used to setup a new Home Hub on the specified device"""
    click.echo("Downloading the latest release from {}...".format(
        __repo__), color=True)
    response = requests.get(
        "https://api.github.com/repos/{}/releases/latest".format(__repo__))

    if response.status_code != 200:
        if response.status_code == 404:
            click.echo("Failed to find the latest release in {}. If you keep running into this issue, please file an issue at https://github.com/cedricgrothues/home-automation/issues".format(
                __repo__), err=True)
        else:
            click.echo("Unexpected issue when checking out the current release: status code {}. If you keep running ito this issue, please file an issue at https://github.com/cedricgrothues/home-automation/issues".format(
                response.status_code), err=True)
        return

    repository = requests.get(response.json()["zipball_url"])

    if repository.status_code != 200:
        click.echo("Could not download repository from zipball_url", err=True)
        return

    try:
        if not os.path.exists("./tmp"):
            os.mkdir("./tmp")
        file = open("./tmp/tmp.zip", "wb+")
        file.write(repository.content)
        zip = zipfile.ZipFile(file)
        for f in zip.namelist():
            if re.match('^.+\.(go|mod|sum|py)$', f):
                zip.extract(re.sub(r'(?is)[0-9a-zA-Z\-]+/', '', f), "./tmp/")
        zip.close()
        file.close()
        os.remove("./tmp/tmp.zip")
    except IOError as err:
        click.echo("Failed to write to ./tmp folder {}".format(err), err=True)


@application.command()
@click.argument('address')
def update(address):
    """Used to update your Raspberry Pi to the newest Home Hub version"""
    click.echo(address)


@application.command()
@click.argument('address')
def add(address):
    """Used to add a service to the specified home hub"""
    click.echo(address)


if __name__ == "__main__":
    application()
