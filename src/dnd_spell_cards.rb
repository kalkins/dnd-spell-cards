#!/usr/bin/env ruby
require 'optparse'

require_relative 'spell_fetcher'
require_relative 'render'

@options = {
  :verbose => 0,
  :out => "cards.pdf",
  :color => "red",
}

OptionParser.new do |opts|
  opts.on("-v", "--verbose", "Increase log verbosity") do
    @options[:verbose] += 1
  end

  opts.on("-oFILE", "--out FILE", "Save the PDF to this file in the 'out' dir") do |file|
    @options[:out] = file
  end

  opts.on("--spells SPELLS", Array, "The spells to turn into cards") do |spells|
    @options[:spell_index] = spells
  end

  opts.on("--classes CLASSES", Array, "The classes to get spells for") do |classes|
    @options[:spell_classes] = classes
  end

  opts.on("--levels LEVELS", Array, "The levels of spells to get. Only works with --classes") do |levels|
    @options[:spell_levels] = levels.map(&:to_i)
  end

  opts.on("-cCOLOR", "--color COLOR", "The color of the cards") do |color|
    @options[:color] = color
  end
end.parse!

fetcher = SpellFetcher.new

spells = []

if @options.key?(:spell_classes) or @options.key?(:spell_levels)
  classes = @options[:spell_classes] || :all
  levels = @options[:spell_levels] || :all

  spells += fetcher.fetch_by_class(classes, levels)
end

additional_indexes = []

if @options.key?(:spell_index)
  @options[:spell_index].each { |index|
    if index.start_with? '-'
      index.slice! '-'
      spells = spells.filter { |spell|
        spell["index"] != index
      }
    else
      if not spells.any? { |spell| spell["index"] == index }
        additional_indexes.push index
      end
    end
  }
end

if additional_indexes.size > 0
  spells += fetcher.fetch_by_index(additional_indexes)
end

render_cards spells, "out", @options[:out], @options[:color]
