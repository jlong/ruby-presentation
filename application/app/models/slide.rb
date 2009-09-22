gem "RedCloth", :version => "2.0.11"
require 'redcloth'
require 'syntax'
require 'syntax/lang/ruby'
require 'syntax/convertors/html'

class Slide
  cattr_accessor :slide_root
  @@slide_root = File.join(RAILS_ROOT, 'slides')
  
  attr_accessor :previous, :next, :index, :body
  
  def initialize(filename)
    open(filename) do |f|
      @body = f.read
    end
  end
  
  def title
    if @title
      @title
    else
      %r{<h1.*?>(.*?)</h1>}.match(to_html)
      @title = $1
    end
  end
  
  def to_html
    @html ||= begin
      text = @body.dup
      text = format_ruby_code(text)
      text = RedCloth.new(text).to_html
    end
  end
  
  private
  
    def format_ruby_code(text)
      text.gsub(%r{<code>\s*(.*?)\s*</code>}m) do
        lines = Syntax::Convertors::HTML.new(Syntax::Ruby.new).convert($1)
        lines = lines.gsub(%r{<pre>(.*?)</pre>}m) do
          $1
        end
        code = ''
        lines.each_line do |line|
          if line =~ /\A\s*\z/
            code << %{<div class="blank-line">&nbsp;</div>}
          else
            line = line.gsub(/\A(\s+)/) do
              '&nbsp;' * $1.size
            end
            code << %{<div class="line">#{line}</div>}
          end
        end
        %{<notextile><div class="code-window"><div class="code">#{code}</div></div></notextile>}
      end
    end

  class << self
    def index
      open(File.join(@@slide_root, 'index.txt')) do |f|
        filenames = f.read.split("\n")
        filenames = filenames.collect { |f| f.strip }
        filenames.delete_if { |f| f.empty? or f =~ /^\s*#/ }
        filenames
      end
    end
    
    def find(number, filenames = index)
      p = number - 1
      p = nil if p < 1
      n = number + 1
      n = nil if n > filenames.size
      slide = create(filenames[number-1])
      if slide
        slide.previous = p
        slide.next = n
        slide.index = number
      end
      slide
    end
    
    def find_all(filenames = index)
      slides = []
      filenames.each_with_index do |fname, i|
        slides << find(i+1)
      end
      slides
    end
    
    def create(filename)
      new(File.join(@@slide_root, filename)) if filename
    end
  end
end
