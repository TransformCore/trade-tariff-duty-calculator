module Api
  class GeographicalArea < Api::Base
    EU = '1013'.freeze
    UK = %w[GB].freeze

    has_many :children_geographical_areas, GeographicalArea

    attributes :id,
               :geographical_area_id,
               :description

    def id
      geographical_area_id
    end

    def name
      description.html_safe
    end

    def european_union?
      geographical_area_id == EU
    end

    def self.list_countries(service)
      countries = build_collection(service, 'Country')
      countries << northern_ireland if service == :uk
      countries
    end

    def self.other_countries(service = :xi)
      eu_ids = european_union_members(service).map(&:geographical_area_id).concat(UK)
      build_collection(service, 'Country')
        .reject { |country| eu_ids.include?(country.geographical_area_id) }
    end

    def self.european_union_members(service = :xi)
      build_collection(service).find(&:european_union?).children_geographical_areas
    end

    def self.eu_member?(geographical_area_id)
      european_union_members.map(&:geographical_area_id).include?(geographical_area_id)
    end

    def self.find(id, service = :uk)
      build_collection(service).find { |geographical_area| geographical_area.id == id }
    end

    def self.northern_ireland
      new(id: 'XI', description: 'United Kingdom (Northern Ireland)', geographical_area_id: 'XI')
    end
  end
end
