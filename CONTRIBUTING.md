# Contributing to Docker Documentation

We value documentation contributions from the Docker community. We'd like to
make it as easy as possible for you to work in this repository.

Our style guide and instructions on using our page templates and components is
available in the [contribution section](https://docs.docker.com/contribute/) on
the website.

The following guidelines describe how to contribute to the
Docker documentation at <https://docs.docker.com/>, and how to get started.

## Reporting issues

If you encounter a problem with the content, or the site in general, feel free
to [submit an issue](https://github.com/docker/docs/issues/new/choose) in our
[GitHub issue tracker](https://github.com/docker/docs/issues). You can also use
the issue tracker to raise requests on improvements, or suggest new content
that you think is missing or that you would like to see.

## Editing content

The website is built using [Hugo](https://gohugo.io/). The content is primarily
Markdown files in the `/content` directory of this repository (with a few
exceptions, see [Content not edited here](#content-not-edited-here)).

The structure of the sidebar navigation on the site is defined by the site's
section hierarchy in the `contents` directory. The titles of the pages are
defined in the front matter of the Markdown files. You can use `title` and
`linkTitle` to define the title of the page. `title` is used for the page
title, and `linkTitle` is used for the sidebar title. If `linkTitle` is not
defined, the `title` is used for both.

You must fork this repository to create a pull request to propose changes. For more details, see [Local setup](#local-setup).

### General guidelines

Help make reviewing easier by following these guidelines:

- Try not to touch a large number of files in a single PR if possible.
- Don't change whitespace or line wrapping in parts of a file you aren't
  editing for other reasons. Make sure your text editor isn't configured to
  automatically reformat the whole file when saving.
- We use GitHub Actions for testing and creating preview deployments for each
  pull request. The URL of the preview deployment is added as a comment on the
  pull request. Check the staging site to verify how your changes look and fix
  issues, if necessary.

### Local setup

You can use Docker (surprise) to build and serve the files locally.

> [!IMPORTANT]
> This requires Docker Desktop version **4.24** or later, or Docker Engine with Docker
> Compose version [**2.22**](https://docs.docker.com/compose/how-tos/file-watch/) or later.

1. [Fork the docker/docs repository.](https://github.com/docker/docs/fork)

2. Clone your forked docs repository:

   ```console
   $ git clone https://github.com/<your-username>/docs
   $ cd docs
   ```

3. Configure Git to sync your docs fork with the upstream docker/docs
   repository and prevent accidental pushes to the upstream repository:

   ```console
   $ git remote add upstream https://github.com/docker/docs.git
   $ git remote set-url --push upstream no_pushing
   ```

4. Check out a branch:

   ```console
   $ git checkout -b <branch>
   ```

5. Start the local development server:

   ```console
   $ docker compose watch
   ```

The site will be served for local preview at <http://localhost:1313>. The
development server watches for changes and automatically rebuilds your site.

To stop the development server:

1. In your terminal, press `<Ctrl+C>` to exit the file watch mode of Compose.
2. Stop the Compose service with the `docker compose down` command.

> [!NOTE]
> Alternatively, if you have installed Hugo, you can build with `hugo serve`.

### Testing

Before you push your changes and open a pull request, we recommend that you
test your site locally first. Local tests check for broken links, incorrectly
formatted markup, and other things. To run the tests:

```console
$ docker buildx bake validate
```

If this command doesn't result in any errors, you're good to go!

## Content not edited here

CLI reference documentation is maintained in upstream repositories. It's
partially generated from code, and is only vendored here for publishing. To
update the CLI reference docs, refer to the corresponding repository:

- [docker/cli](https://github.com/docker/cli)
- [docker/buildx](https://github.com/docker/buildx)
- [docker/compose](https://github.com/docker/compose)

Feel free to raise an issue on this repository if you're not sure how to
proceed, and we'll help out.

Other content that appears on the site, but that's not edited here, includes:

- Dockerfile reference
- Docker Engine API reference
- Compose specification
- Buildx Bake reference

If you spot an issue in any of these pages, feel free to raise an issue here
and we'll make sure it gets fixed in the upstream source.
