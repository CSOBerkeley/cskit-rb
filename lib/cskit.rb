# encoding: UTF-8

module CSKit

  autoload :Annotator,       'cskit/annotator'
  autoload :Annotation,      'cskit/annotator'
  autoload :AnnotatedString, 'cskit/annotated_string'
  autoload :Formatters,      'cskit/formatters'
  autoload :Lesson,          'cskit/lesson'
  autoload :Parsers,         'cskit/parsers'
  autoload :Readers,         'cskit/readers'
  autoload :Registry,        'cskit/registry'
  autoload :RegistryFactory, 'cskit/registry'
  autoload :Volume,          'cskit/volume'
  autoload :Volumes,         'cskit/resources/volumes'

  extend Registry

  family :volume, :volumes
  family :annotator, :annotators

end
