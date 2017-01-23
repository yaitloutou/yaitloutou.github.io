---
title: Jekyll code highlighing
category: webdev
tag: [jekyll,code highlight,scss]
---

```javascript
function order(words){
  var array = words.split(' ');
  var result = array.slice();

  for (word in array) {
    for (var i = 0; i < array[word].length; i++) {
       if (!isNaN(array[word][i])) {
         result[array[word][i] - 1] = array[word]
       }
     }
   }return result.join(' ');
}
```

---

To get code highlighted in jekyll, you need to check 3 things:

1. the _highlighter_ and the _markdown processors_ are correctly configured in `_config.yml`
2. your code block is correctly formatted.
3. the generated html files have access to a CSS highlighting-syntax style rules

# 1. Highlighter and the markdown processors configuration

As of jekyll 3.0, Kramdown as the Markdown engine, and Rouge as the syntax highlighter. are the [default jekyll setting][3], and the only setting supported by [github pages][4].

So you can safely remove their related setting, or set it at  `_config.yml` as follows:

```ruby
# Conversion
markdown:    kramdown
highlighter: rouge

# Markdown Processors
kramdown:
  input: GFM
  auto_ids: true
  syntax_highlighter: rouge
```

# 2. Code block

> A code block can be started by using four spaces or one tab and then the text of the code block
>
> -- [kramdown docs][6]

for [fenced code block][7] you can use `~~~` or <code>```</code> the  [github way][9] with Github Flavored Markdown parser [Kramdown::GFM][8] (the default one).

You can also wrap the code in `{%raw%}{%highlight javascript%}... {%endhighlight%}{%endraw%}` blocks.

# 3. Code highlighting style:

the generated html file **should have access** to some CSS code-highlighting rules. that depends on the theme that you're working with.

One way to do so, is to have a code-highlighting style rules defined in the main css file, then include that file in the html head of the _default layout_.

## define the CSS code-highliting rules

Make sure that the main CSS file, (located at `/assets/css`, and usually named `main.scss` or `style.scss`) has some code highlight CSS rules defined, either explicitly defined there, or by importing a file (scss, sass, or less) that contains the CSS rules.

for a quick check, I've putted some scss code-highlighting themes in this [repo][5]

- clone [sass-code-highlight][5] repo
- put `sass-code-highlight` folder inside  the sass directory (by default: `_sass`)
- inport the code-highlight to the main css file

in `assets/css/main.scss` add the following:

```scss
@import "sass-code-highlight/monokai"; // 'monokai' as example
```

## include the Main CSS in the HTML HEAD

you need to have the sinppet bellow in the default layout (`_layouts/default.html`)

```html
<head>
  <!-- head stuff-->

  <!-- CSS -->
  <link rel="stylesheet" type="text/css" href="{{site.baseurl}}/assets/css/main.css"> <!-- IMPORTANT -->
</head>
```

either directly, or by including a `head.html`file - defined in `_includes` directory - into it, as follows:

```html
<!DOCTYPE html>
<html lang="en">
  {% raw %}{% include head.html %} <!--  <- include the head -->{% endraw %}
  <body>
  {% raw %}{{ content }}{% endraw %}
  </body>
</html>
```

**Note:** make sure that the `href="css/path/"` is valid. e.g `{% raw %}{{site.baseurl}}{% endraw %}` is croectly setted

[3]: https://jekyllrb.com/docs/configuration/
[4]: https://github.com/blog/2100-github-pages-now-faster-and-simpler-with-jekyll-3-0
[5]: https://github.com/yaitloutou/sass-code-highlight
[6]: https://kramdown.gettalong.org/syntax.html#code-blocks
[7]: https://kramdown.gettalong.org/syntax.html#fenced-code-blocks
[8]: https://kramdown.gettalong.org/parser/gfm.html
[9]: https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#code-and-syntax-highlighting
