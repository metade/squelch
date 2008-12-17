# ENV['HTTP_PROXY'] = 'http://www-cache.reith.bbc.co.uk:80'
Shoes.setup do
  gem 'cucumber'
end
require 'rubygems'
require 'cucumber'
require 'cucumber/treetop_parser/feature_en'

Cucumber.load_language('en')

Shoes.app(:title => "Squelch! I've got Cucumber in my Shoes...", :width => 500, :height => 500) do
  def execute_feature_file(file)
    io = StringIO.new
    step_mother = Cucumber::StepMother.new
    formatters = Cucumber::Broadcaster.new [ Cucumber::Formatters::PrettyFormatter.new(io, step_mother) ]
    executor = Cucumber::Executor.new(step_mother)
    executor.formatters = formatters
    parser = Cucumber::TreetopParser::FeatureParser.new
    feature = parser.parse_feature(file)
    executor.visit_features(feature)
    formatters.dump
    Term::ANSIColor.uncolored(io.string)
  end
  
  def run_cucumber
    if @file.nil?
      alert("You must load a file first!")
      return
    end
    begin
      @result.style(:stroke => black)
      @result.text = execute_feature_file(@file)
    rescue => e
      @result.style(:stroke => red)
      @result.text = e.message
    end
  end
  
  background white
  
  stack do
    background "#44562E"
    flow(:height => 30) do
      button "Open File..." do
        @file = ask_open_file
        @file_path.text = @file
        run_cucumber
      end
      @file_path = inscription(@file, :right => 0, :stroke => white)
    end
    
    # http://flickr.com/photos/vizzzual-dot-com/2738586453/
    image('images/cucumber.jpg', :click => Proc.new() { run_cucumber}) 
    flow(:width => 500, :height => 500, :scroll => true) do
      @result = para('')
    end.move(0, 30)
  end
end
