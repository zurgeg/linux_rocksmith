# How does this work?

I have the base structure in base.md. I've got a bunch of files in a bunch of folders. The folder-structure, as well as the file names are decided by what I need. It then gets compiled by the generate.sh and put in the [guides/setup folder](../guides/setup) in the repo.

See the [diagram.txt](diagram.txt) for the structure where the replace strings come from.

# But why do you do this?

There currently are 10 versions of my guide (2 of which are incomplete). If there was 1 error, I would potentially have to correct it in 10 files. With this structure, I only need to do it in a few files (sometimes only 1) and just regenerate the files again.

The downside of this is the complex structure.

# How is it built?

Refer to the comment block and the other comments inside the [generate.sh](generate.sh)

# Why Tabs instead of Spaces?

I don't discriminate against liking a different indentation width than me.

&nbsp;

(No, I don't feel discriminated by using spaces. Just annoyed ^^)
