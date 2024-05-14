require 'squib'

def render_cards spells, out_dir, out_file
  Squib::Deck.new cards: spells.size do
    rect

    spells.each_with_index { |spell, i|
      text range: i,
           str: spell.name
    }

    save_pdf file: out_file, dir: out_dir
  end
end
