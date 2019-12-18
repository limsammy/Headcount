## Headcount

Find the assignment here: https://github.com/turingschool/curriculum/blob/master/source/projects/headcount.markdown

This Mod1 final project requires students to create their own ORM with Ruby.  Students are tasked to consume CSV's with data about the Colorado school districts, store it in an effecient way and produce terminal output that responds to certain queries.

This project goes one step further utilizing Ruby's ability to output HTML through ERB to generate a static website to display this data.  When building the static site, Ruby uses `nokogiri` and `httparty` to search Wikipedia and scrape the information table for each district. This is accomplished without the use of Sinatra, Rails or PostGres.  [You can view the static site on GitHub Pages](http://iamchrissmith.io/headcount/)

### Getting Started

1. After you've cloned and cd'd into the directory, install dependencies with `bundle install`
2. Make sure everything is running smoothly by running the test suite with `rake test`
3. Assuming nothing fails, you will now need to prep the data. To see the available rake tasks we've defined, use `rake --tasks`
4. Running `rake sanitation:all` will prep the data for our somewhat shaky, prone-to-exceptions, custom handrolled ORM :)
5. The data has been sanitized, now it's time to run the build task! Use `rake build` -- This will probably take a moment or two, please be patient, we didn't even know multi-threading and parallelism were a thing when we made this!

Finally, when the build task finishes, you can view the static generated web app that visualizes some of this data and showcases the BI we developed.
