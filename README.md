Ruby DANFE
==========

This is a component for generating PDF files for Brazilian DANFE ("Documento
Auxiliar da Nota Fiscal Eletrônica") from a valid NFE XML. 

Inspired on NFePHP class [http://www.assembla.com/wiki/show/nfephp/DanfeNFePHP].

Installing
==========

    gem install ruby_danfe
    
Usage
=====

    require 'ruby_danfe'
    
    RubyDanfe.generate('sample.pdf', 'sample.xml')
    
    
