require 'http'
require 'json'

class SpellFetcher
  API_HOST = "https://www.dnd5eapi.co/"

  def fetch_by_index(spells)
    spells.map { |spell|
      url = API_HOST + "api/spells/#{spell}"

      response = HTTP.get(url)

      if response.status.success?
        JSON.parse(response.body)
      else
        error = response.body
        puts "Error while fetching #{spell}: #{error}"
        exit
      end
    }
  end

  def fetch_by_level(levels)
    url = API_HOST + "api/spells/"

    response = HTTP.get(url)

    if response.status.success?
      data = JSON.parse(response.body)

      self.fetch_by_index(
        data["results"].filter { |spell|
          levels == :all or levels.include? spell["level"]
        }.map { |spell|
          spell["index"]
        }
      )
    else
      error = response.body
      puts "Error while fetching list of all spells: #{error}"
      exit
    end
  end

  def fetch_by_class(classes, levels)
    fetch_by_level(levels).filter { |spell|
      classes == :all or classes.any? { |class_name|
        (spell["classes"] + spell["subclasses"]).any? { |api_class|
          api_class["index"] == class_name or api_class["name"] == class_name
        }
      }
    }
  end
end
