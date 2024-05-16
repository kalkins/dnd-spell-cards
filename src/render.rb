require 'squib'

def render_cards spells, out_dir, out_file, color
  Squib::Deck.new width: "64mm", height: "93mm", cards: spells.size, layout: "layouts/card-front.yaml" do
    background color: color

    rect layout: :NameBox
    rect layout: :DescriptionBox

    spells.each_with_index { |spell, i|
      text range: i,
           layout: :Name,
           str: spell["name"]

      text range: i,
           layout: :Description,
           str: spell["desc"].join("\n")
    }

    save_pdf file: out_file, dir: out_dir, sprue: "sprue/a4x9.yaml"
  end
end
