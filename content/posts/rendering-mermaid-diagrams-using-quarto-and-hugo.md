---
title: Rendering Mermaid Diagrams on a Hugo Website Using Quarto
summary: How to get your mermaid diagrams to show up on your Hugo blog when using Quarto, so that you don't have to go through the same trial and error nightmare that I did!
date: 2022-09-17
tags:
    - Quarto
    - Mermaid
    - Hugo
category: quarto
keywords:
    - quarto
    - markdown
    - hugo
    - mermaid
mermaid: true
---

<script  src="rendering-mermaid-diagrams-using-quarto-and-hugo_files/libs/quarto-diagram/mermaid.min.js"></script>
<script  src="rendering-mermaid-diagrams-using-quarto-and-hugo_files/libs/quarto-diagram/mermaid-init.js"></script>
<link  href="rendering-mermaid-diagrams-using-quarto-and-hugo_files/libs/quarto-diagram/mermaid.css" rel="stylesheet" />

I find a lot of the methods for drawing diagrams and flow charts using code to be a bit of a nightmare. I'm not sure what it is, perhaps I'm just a bit stupid, but they always seem a little more convoluted than I can handle. It's possible that the design is actually of some value when it comes to drawing diagrams that are much larger and more complicated than I am generally dealing with, but in my case, it always seems to be a lot of work for what little I'm trying to do.

The easiest, most intuitive way that I've come across is using a JavaScript library called Mermaid. It's just very easy, and the diagrams look great. Even better is the fact that it works with a lot of Markdown formats, and it's even one of the diagram formats that Quarto can handle.

One issue that I came across, however, is that Mermaid diagrams don't render when you're using Quarto to create Hugo Markdown files for a Hugo website. You do have some simple options to resolve this, such as setting the `mermaid-format` to PNG or SVG in the article front matter, but with just a little extra work, you can get Mermaid working perfectly on your Hugo website.

## Setting up Hugo to Support Mermaid

Steps for setting up Hugo to support Mermaid are detailed in the [Hugo documentation](https://gohugo.io/content-management/diagrams/), however that didn't seem to work for me (producing errors when Netlify tries to publish the site). Instead, I had to take a slightly different approach, which was inspired by Kevin Wu's [blog post](https://kvwu.io/posts/hugo-shortcode/) about using Mermaid with Hugo. This **should** work for others, but if it doesn't, please lets just assume that it is either Kevin's fault, or your fault, but definitely not my fault.

First, create a HTML file `/layours/partials/mermaid.html`, and add the following code, which specifies where to find Mermaid and how it should be loaded (in this case I've specified the dark theme, but there's a few different options):

``` html
<script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
<script>mermaid.initialize({startOnLoad:true, theme:"neutral" });</script>
```

Following this, a snippet needs to be added to one of the partial layouts that will be used in your content pages. I added it to the `extend_head.html` file (which, as the name helpfully suggests, is just an extension of `head.html`). This snippet just tells Hugo that, when Mermaid is called in the frontmatter, it needs to use the `mermaid.html` partial you just created.

``` html
{{ if .Page.Params.mermaid }}
{{ partial "mermaid.html" . }}
{{ end }}
```

This can either be added to the existing theme partial, located in `themes/<theme-name>/layouts/partials`, or it can be in the global `layouts/partials` directory, which will override your theme.

Now, you just have to add `mermaid: true` to the YAML frontmatter for any page that contains a Mermaid code block, and you're good to go!

## Rendering Mermaid Using Quarto

Once you've set Hugo up to handle Mermaid code blocks, you would think it should then render like other code chunks in Quarto, and you would be right. Mermaid is very good.

I find that I sometimes have to render the Quarto document a couple times for Mermaid diagrams to show up, or for changes to render properly, but that's about the only issue that I've come up against.

### Flowcharts

The diagram I will get the most use out of is flowcharts, and Mermaid makes them really easy.

```` markdown
```{mermaid}
%%| label: fig-mermaid-flowchart
%%| fig-cap: Wow look how it flows.

graph LR
    A([Oooh]) --> B([Would You])
    B --> C([Look at This])
    C --> D[Very]
    C --> E[Fancy]
    C --> F[Flowchart]
```
````

<p>
<pre class="mermaid mermaid-js" data-tooltip-selector="#mermaid-tooltip-1">
graph LR
    A([Oooh]) --&gt; B([Would You])
    B --&gt; C([Look at This])
    C --&gt; D[Very]
    C --&gt; E[Fancy]
    C --&gt; F[Flowchart]
</pre>

</p>

Figure 1: Wow look how it flows.

### Gantt Charts

If [Figure 1](#fig-mermaid-flowchart) isn't enough to convince you, how about some Gantt charts?

```` markdown
```{mermaid}
%%| label: fig-mermaid-gantt
%%| fig-cap: Oh you real fancy huh?

%%{init: {'theme': 'default', 'themeVariables': { 'textColor': '#798189'}}}%%
gantt
    title Big Ol' Gantts
    dateFormat  YYYY-MM-DD
    section Section
    Some Normal Tasks : done, a1, 2022-09-01, 15d
    But Wait, There's More! :after a1, 20d
    section And ANOTHER
    Deary Me, It's Never Ending : crit, 2022-10-01, 20d
    I Hate This Project : 14d
```
````

<p>
<pre class="mermaid mermaid-js" data-tooltip-selector="#mermaid-tooltip-2">
%%{init: {&#39;theme&#39;: &#39;default&#39;, &#39;themeVariables&#39;: { &#39;textColor&#39;: &#39;#798189&#39;}}}%%
gantt
    title Big Ol&#39; Gantts
    dateFormat  YYYY-MM-DD
    section Section
    Some Normal Tasks : done, a1, 2022-09-01, 15d
    But Wait, There&#39;s More! :after a1, 20d
    section And ANOTHER
    Deary Me, It&#39;s Never Ending : crit, 2022-10-01, 20d
    I Hate This Project : 14d
</pre>

</p>

Figure 2: Oh you real fancy huh?

The dark and light theme my Hugo site uses doesn't handle the Gantt chart as well as the other Mermaid diagrams. If I use the neutral Mermaid theme, it doesn't show as clearly when using the dark Hugo theme, and vice versa with the dark Mermaid theme and light Hugo theme. This isn't ideal, but you can [customise the appearance](https://mermaid-js.github.io/mermaid/#/theming?id=theme-variables-reference-table) of your Mermaid diagrams too.

I've stuck with the neutral Mermaid theme for the rest of the site because it seems to be the best fit for flowcharts with the two different Hugo themes, and flowcharts are the diagrams I'm going to be using Mermaid for most often on this site. However, for this Gantt chart I've customised the appearance a little, using `%%init%%`, using the default theme and a grey text colour that works slightly better (though it's still not brilliant).

### Git Graphs

So you've got [Figure 1](#fig-mermaid-flowchart) to wow people with your idea and [Figure 2](#fig-mermaid-gantt) to manage the project, but now you need some git graphs to show how you broke everything.

```` markdown
```{mermaid}
%%| label: fig-mermaid-git
%%| fig-cap: Git a load of this!

gitGraph
  commit
  commit
  branch develop
  checkout develop
  commit
  commit
  checkout main
  merge develop
  commit
  commit
```
````

<p>
<pre class="mermaid mermaid-js" data-tooltip-selector="#mermaid-tooltip-3">
gitGraph
  commit
  commit
  branch develop
  checkout develop
  commit
  commit
  checkout main
  merge develop
  commit
  commit
</pre>

</p>

Figure 3: Git a load of this!

## Conclusion

And that's about all you need to do. Think of all the amazing diagrams you're going to create and show the world? I, on the other hand, am going to continue to make minimal diagrams that are completely uninspiring. Have fun!
