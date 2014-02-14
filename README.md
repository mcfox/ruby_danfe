# Ruby DANFE

It generates PDF files for Brazilian DANFE (_Documento Auxiliar da Nota Fiscal Eletrônica_) from a valid NF-e XML.

It also generates Brazilian DACTE (_Documento Auxiliar do Conhecimento de Transporte Eletrônico_).

This project is inspired on [NFePHP class](http://www.assembla.com/wiki/show/nfephp/DanfeNFePHP).

## Installing

        gem install ruby_danfe

## Usage

If you have the xml saved in a file:

        require "ruby_danfe"
        RubyDanfe.generate("sample.pdf", "sample.xml")

If you have the xml in a variable:

        xml = "string xml"
        pdf = RubyDanfe.generatePDF(xml)
        pdf.render_file "output.pdf"

You can use some options too! In this example, the product's field quantity will be rendered with 4 decimals after comma:

        xml = "string xml"
        RubyDanfe.options = {"quantity_decimals" => 4}
        pdf = RubyDanfe.generatePDF(xml)
        pdf.render_file "output.pdf"

If you have some especific option that is global for your project, you can create a file at config/ruby_danfe.yml, then the ruby_danfe always will load this options. Example:

        project_name/config/ruby_danfe.yml

        ruby_danfe:
          options:
            quantity_decimals: 3
            numerify_prod_qcom: false


## Development

### Installing dependencies

You can install all necessaries dependencies using bunder like above:

        $ bundle install

### Tests

#### Manual tests

At `test` folder you will find the `generate.rb` file. It shows how to generate a pdf file from a valid xml.

You can use it following the steps above:

        $ cd test
        $ ruby generate.rb nfe_with_ns.xml

You can also use an special version of irb with all classes pre-loaded. Just use:

        $ rake console
        RubyDanfe.generate("output.pdf", "test/nfe_with_ns.xml")

or

        $ rake console
        my_xml_string = ""
        file = File.new("test/nfe_with_ns.xml", "r")
        while (line = file.gets)
            my_xml_string = my_xml_string + line
        end
        file.close

        xml = RubyDanfe::XML.new(my_xml_string)
        pdf = RubyDanfe.generatePDF(xml)

        pdf.render_file "output.pdf"

#### Automated tests with RSpec

You can run all specs using:

        $ rspec

In the `spec/fixtures` folder, you are going to find some xml files. Each one represent a different NF-e context.

Each xml file must have its respective pdf file.

If you did some change that caused general visual changes at output pdfs, so you have to rebuild all fixtures pdf files.

You can do this automagically running the following taks:

        $ rake spec:fixtures:recreate_pdfs

#### Code coverage

Code coverage is available through of SimpleCov. Just run `rspec` and open the coverage report in your browser.

### Building and publishing

You can build using one of the above tasks

        $ rake build    # Build ruby_danfe-X.X.X.gem into the pkg directory
        $ rake install  # Build and install ruby_danfe-X.X.X.gem into system gems
        $ rake release  # Create tag vX.X.X and build and push ruby_danfe-X.X.X.gem to Rubygems

## Contributing

We encourage you to contribute to Ruby DANFE!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Ruby DANFE is released under the [MIT License](http://www.opensource.org/licenses/MIT).
