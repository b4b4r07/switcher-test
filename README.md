github-buttons
==============

[![Circle CI](https://circleci.com/gh/ntkme/github-buttons.svg?style=svg)](https://circleci.com/gh/ntkme/github-buttons)

To get started, checkout **[buttons.github.io](https://buttons.github.io)**!

## Manual

### Example

``` html
<a href="https://github.com/ntkme" class="github-button"
  data-count-href="/ntkme/followers" data-count-api="/users/ntkme#followers">Follow @ntkme</a>
<a href="https://github.com/ntkme/github-buttons" class="github-button" data-icon="octicon-star"
  data-count-href="/ntkme/github-buttons/stargazers" data-count-api="/repos/ntkme/github-buttons#stargazers_count">Star</a>
<a href="https://github.com/ntkme/github-buttons/fork" class="github-button" data-icon="octicon-git-branch"
  data-count-href="/ntkme/github-buttons/network" data-count-api="/repos/ntkme/github-buttons#forks_count">Fork</a>
<a href="https://github.com/ntkme/github-buttons/issues" class="github-button" data-icon="octicon-issue-opened"
  data-count-api="/repos/ntkme/github-buttons#open_issues_count">Issue</a>

<script async defer id="github-bjs" src="https://buttons.github.io/buttons.js"></script>
```

### Usage

Add as many `<a class="github-button">` as you like, then put the `<script>` after the last one.

### Syntax

``` html
<a class="github-button"
   href="{{ link }}"
   data-icon="{{ octicon }}"
   data-count-href="{{ count_link }}"
   data-count-api="{{ count_api }}"
   data-style="{{ style }}"
   data-text="{{ button_text }}"
   >{{ text }}</a>
```

``` html
<script async defer id="github-bjs" src="https://buttons.github.io/buttons.js"></script>
```

#### Attributes

| Attribute         | Description                                                                                                                                     |
| ---------         | -----------                                                                                                                                     |
| `href`            | GitHub link for the button.                                                                                                                     |
| `data-icon`       | Octicon for the button. It defaults to `octicon-mark-github`. <br> All available icons can be found at [Octicons](https://octicons.github.com). |
| `data-count-href` | GitHub link for the count. It defaults to `href` value. <br> Relative url will be relative to `href` value.                                     |
| `data-count-api`  | GitHub API endpoint for the count.                                                                                                              |
| `data-style`      | `default` or `mega`.                                                                                                                            |
| `data-text`       | Text displayed on the button. This option will override `link_text`.                                                                            |
| `text`            | Text displayed on the button and the fallback link.                                                                                             |

#### API Endpoint

You can use any GitHub API endpoint that supports GET request.  

You must append a `#hash` to the endpoint to extract a value for the count from the JSON response.  
e.g. `/users/octocat#followers` will extract `followers` from the JSON.  

You can also access specific subnode in the JSON.  
e.g. `/repos/octocat/hello-world#owner.login` will extract `owner.login`.  
e.g. `/users/octocat/repos#[0].open_issues_count` will extract `open_issues_count` from the first enrty in the array.  

See [GitHub Developer](https://developer.github.com) for API references.



Development
-----------

### Dependencies

- Node.js
- PhantomJS

### Clone

``` sh
git clone --recursive https://github.com/ntkme/github-buttons.git
```

``` sh
cd github-buttons && npm install
```

### Build

``` sh
cake build
```

### Test

``` sh
cake test
```



License
-------

See [LICENSE.md](LICENSE.md).
