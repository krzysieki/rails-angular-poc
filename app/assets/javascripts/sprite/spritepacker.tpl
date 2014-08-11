{{#sprites}}

.ico-{{name}} 
  background-image url('{{../baseUrl}}{{../fileName}}')
  background-position round(-({{x}}/2)px) round(-({{y}}/2)px) 
  width round({{width}} / 2)px 
  height round({{height}} / 2)px 
  display inline-block
  overflow hidden
  background-size round( image-size('icons.png')[0] / 2 )  round( image-size('icons.png')[1] / 2 )
{{/sprites}}
