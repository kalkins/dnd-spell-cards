require 'http'
require 'json'

Spell = Struct.new(:name, :description, keyword_init: true)

class SpellFetcher
  API_HOST = "https://www.dnd5eapi.co/"

  def fetch_by_index(spells)
    spells.map { |spell|
      url = API_HOST + "api/spells/#{spell}"

      response = HTTP.get(url)

      if response.status.success?
        data = JSON.parse(response.body)

        Spell.new(
          name: data["name"],
          description: data["desc"].join("\n"),
        )
      else
        error = response.body
        puts "Error while fetching #{spell}: #{error}"
        exit
      end
    }
  end
end
