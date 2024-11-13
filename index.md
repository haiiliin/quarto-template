---
title: "Quarto template for writing academic papers"

author:
  - name: Hai-Lin Wang
    orcid: 0000-0001-5759-2455
    email: hailin.wang@connect.polyu.hk
    affiliation:
      - Department of Civil and Environmental Engineering, The Hong Kong Polytechnic University, Hong Kong, China
      - Department of Geotechnical Engineering, College of Civil Engineering, Tongji University, Shanghai, China
  - name: Zhen-Yu Yin
    orcid: 0000-0003-4154-7304
    email: zhenyu.yin@polyu.edu.hk
    corresponding: true
    affiliation:
      - Department of Civil and Environmental Engineering, The Hong Kong Polytechnic University, Hong Kong, China
  - name: Xiao-Qiang Gu
    email: guxiaoqiang@tongji.edu.cn
    affiliation:
      - Department of Geotechnical Engineering, College of Civil Engineering, Tongji University, Shanghai, China
  - name: Yin-Fu Jin
    orcid: 0000-0003-0522-1702
    email: yinfujin@szu.edu.cn
    affiliation:
      - College of Civil and Transportation Engineering, Shenzhen University, Shenzhen, China

abstract: |
  The [quarto-template](https://github.com/haiiliin/quarto-template) is a Quarto template for writing academic papers. The template is based on the [Quarto](https://quarto.org) document system, which is a document system that supports the entire research lifecycle, from initial exploration to final publication. The template provides a simple and clean layout for writing academic papers, which is suitable for researchers who want to focus on the content of the paper rather than the formatting.

keywords:
  - Manuscript
  - Template

bibliography:
  - references.bib
---

# Prerequisites

To use the template, you need to have the Quarto document system installed on your computer. You can install Quarto by following the instructions on the [Quarto website](https://quarto.org/docs/getting-started/).

To render the paper to PDF, you also need to have a LaTeX distribution installed on your computer. You can install LaTeX by following the instructions on the [LaTeX website](https://www.latex-project.org/get/). You can also use the [tinytex](https://yihui.org/tinytex/) package for a lightweight LaTeX distribution:
```sh
quarto install tinytex
```

The GNU Make utility is required to run the commands in the `Makefile`. You can install GNU Make by following the instructions on the [GNU Make website](https://www.gnu.org/software/make/). If you are using Windows, you can install GNU Make from the [GnuWin32](http://gnuwin32.sourceforge.net/packages/make.htm) project.

To clone the repository and run the commands in the `Makefile`, you need to have Git installed on your computer. You can install Git by following the instructions on the [Git website](https://git-scm.com/). If you prefer to use a graphical user interface for Git, you can install [GitHub Desktop](https://desktop.github.com/).

# Usages

## Setup the project

The template is designed to be easy to use, with minimal configuration required. To use the template, simply fork the [quarto-template](https://github.com/haiiliin/quarto-template) repository. You can then clone the repository to your local computer using Git:
```sh
git clone https://github.com/<your-username>/<your-repository>.git
```
Or you can simply open the repository in GitHub Desktop from the browser.

## Start writing

You can now start writing your paper in the `paper.md` file. For more information on how to write papers using the Quarto document system, please refer to the [Quarto documentation](https://quarto.org/docs/guide/).

To configure the metadata of the paper, such as the title, authors, abstract, and article template to use, you can edit the YAML front matter at the beginning of the `paper.md` file and the `_quarto.yml` file.

## Render the paper

To render the paper to PDF, run the following commands in the terminal:
```sh
make fetch  # Fetch the extensions for journal articles
make paper  # Render the paper to docx, html, and pdf files
make clean  # Clean up the intermediate files
```

## Commit and push

After writing the paper, commit and push the changes to your repository. You can then share the link to the repository with your collaborators or submit the paper to a journal for publication.

After every push, the paper will be automatically rendered to docx, html, and pdf files using GitHub Actions. You can download the rendered files from the `Actions` tab of your repository. You can also create GitHub releases to tag specific versions of the paper, which will also trigger the rendering of the paper and the output files will be attached to the release.

A html version of the paper will be published to the `gh-pages` branch of the repository. You can turn on the GitHub Pages feature in the repository settings to publish the html version of the paper to the web. You can then view the paper online by visiting the link provided in the repository settings.

> [!Note]
> You need to turn on the **Read and write permissions** for the **Actions** in the **Settings** of your repository to grant the permission for the GitHub Actions to upload the rendered files.