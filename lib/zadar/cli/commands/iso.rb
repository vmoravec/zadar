zadar do
  desc "Manage iso files and repositories"
  command :iso do |iso|
    iso.desc "Add iso repositories"
    iso.command :addrepo, :ar do |addrepo|
      addrepo.flag [:p, :path]
      addrepo.action do |_, opts,args|
        require 'zadar/services/add_new_iso_repo'

        call { Zadar::Services::AddNewIsoRepo.new(opts.merge(name: args.first)) }
      end
    end

    iso.desc "Add iso files"
    iso.command :addfile, :af do |addfile|
      addfile.flag [:r, :repo]
      addfile.flag [:n, :name]
      addfile.arg_name "filename"
      addfile.action do |_, opts, args|
        require 'zadar/services/add_local_iso_file'

        failure! "Missing repository name" if opts[:repo].to_s.empty?
        call { Zadar::Services::AddLocalIsoFile.new(opts.merge(filename: args.first)) }
      end
    end

    iso.desc "List iso repos"
    iso.command :"listrepos", :lr do |list|
      list.action do |_, options, _|
        require 'zadar/services/find_iso_repos'

        repos = Zadar::Services::FindIsoRepos.new.call.repos
        failure! "No iso repository found" if repos.empty?

        puts Zadar::Models::IsoRepo.columns.columnize
        repos.each {|r| puts r.to_hash.values.columnize }
      end
    end

    iso.desc "List iso files"
    iso.command :"listfiles", :lf do |list|
      list.flag [:r, :repo]
      list.action do |_, options, _|
        require 'zadar/services/find_iso_files'

        failure "Iso repository not specified" unless options[:repo]
        files =  Zadar::Services::FindIsoFiles.new(options).call.files
        failure! "No iso files found" if files.empty?

        puts Zadar::Models::IsoLocalFile.columns.columnize
        files.each {|f| puts f.to_hash.values.columnize }
      end
    end

    iso.desc "Remove iso repositories"
    iso.command :removerepo, :rr do |rm_repo|
      rm_repo.switch :delete
      rm_repo.action do |_, opts, args|
        require "zadar/services/remove_iso_repo"

        call { Zadar::Services::RemoveIsoRepo.new(opts.merge(name: args.first)) }
      end
    end

    iso.desc "Remove iso files"
    iso.command :removefile, :rf do |rm_file|
      rm_file.switch :delete
      rm_file.flag [:r, :repo]
      rm_file.arg_name 'iso file name'
      rm_file.action do |_, opts, args|
        require "zadar/services/remove_local_iso_file"

        call { Zadar::Services::RemoveLocalIsoFile.new(opts.merge(filename: args.first)) }
      end
    end
  end
end
