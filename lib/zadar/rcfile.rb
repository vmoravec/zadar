require 'yaml'
require 'ostruct'

module Zadar
  class Rcfile
    NAME = ".zadarrc"

    def self.create options={}
      new(read_file: false, options: options)
    end

    def self.load
      @file = new
    end

    def self.data
      @file.struct.data
    end

    def self.file
      @file
    end

    attr_reader :content, :path, :struct

    def initialize read_file: true, options: {}
      @path = Pathname.new(Dir.home).join(NAME)
      @content = read_file ? load_content_from_file : create_default_content(options)
      @struct = RcStruct.new(content)
    end

    alias_method :data, :struct

    def save
      File.open(path, 'w') {|file| YAML.dump(struct.to_hash, file) }
    end

    alias_method :update, :save

    private

    def create_default_content options
      raise "Missing name for the new project" unless options[:project_name] || options[:project_path]
      {
        default_project: options[:project_name],
        projects: [ options[:project_name] => { path: options[:project_path] }]
      }
    end

    def load_content_from_file
      YAML.load_file(path)
    end

    class RcStruct
      attr_reader :data

      def initialize content
        @data = OpenStruct.new
        map_content_to_data(content)
      end

      def map_content_to_data content
        content.keys.each do |root_element|
          data[root_element.to_s] = map_element(content[root_element])
        end
      end

      def map_element element
        case element
        when Hash
          result = OpenStruct.new
          element.each_pair {|k, v| result[k] = map_element(v) }
        when Array
          result = []
          element.each {|e| result << map_element(e) }
        when String, Integer
          result = element
        end
        result
      end

      def to_hash
        result = {}
        data.each_pair do |k, v|
          result[k.to_s] = map_hash(v)
        end
        result
      end

      def map_hash element
        case element
        when OpenStruct
          result = {}
          element.each_pair {|k, v| result[k.to_s] = map_hash(v) }
        when Array
          result = []
          element.each {|e| result << map_hash(e) }
        when String, Integer
          result = element
        end
        result
      end
    end
  end
end
