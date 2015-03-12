zadar do
  desc "Manage iso files and repositories"
  command :iso do |iso|
    iso.desc "Add remote repository"
    iso.command :addremoterepo, :arr do |addrepo|
      addrepo.flag [:u, :url]
      addrepo.action do |_, opts, args|
        require 'zadar/services/add_remote_iso_repo'

        name = args.first.to_s
        call { Zadar::Services::AddRemoteIsoRepo.new(opts.merge(name: name)) }
      end
    end


    iso.desc "Add local iso repository"
    iso.command :addlocalrepo, :alr do |addrepo|
      addrepo.flag [:p, :path]
      addrepo.action do |_, opts,args|
        require 'zadar/services/add_local_iso_repo'

        call { Zadar::Services::AddLocalIsoRepo.new(opts.merge(name: args.first)) }
      end
    end

    iso.desc "Add local iso files"
    iso.command :addlocalfile, :alf do |addfile|
      addfile.flag [:r, :repo]
      addfile.flag [:n, :name]
      addfile.arg_name "filename"
      addfile.action do |_, opts, args|
        require 'zadar/services/add_local_iso_file'

        failure! "Missing repository name" if opts[:repo].to_s.empty?
        call { Zadar::Services::AddLocalIsoFile.new(opts.merge(filename: args.first)) }
      end
    end

    iso.desc "List local iso repos"
    iso.command :"listlocalrepos", :llr do |list|
      list.action do |_, options, _|
        require 'zadar/services/find_local_iso_repos'

        repos = Zadar::Services::FindLocalIsoRepos.new.call.repos
        failure! "No iso repository found" if repos.empty?

        puts Zadar::Models::LocalIsoRepo.columns.columnize
        repos.each {|r| puts r.to_hash.values.columnize }
      end
    end

    iso.desc "List local iso files"
    iso.command :"listlocalfiles", :llf do |list|
      list.flag [:r, :repo]
      list.action do |_, options, _|
        require 'zadar/services/find_local_iso_files'

        failure! "Iso repository not specified" unless options[:repo]

        files =  Zadar::Services::FindLocalIsoFiles.new(options).call.files
        failure! "No iso files found" if files.empty?

        puts Zadar::Models::IsoLocalFile.columns.columnize
        files.each {|f| puts f.to_hash.values.columnize }
      end
    end

    iso.desc "Remove local iso repositories"
    iso.command :removerepo, :rr do |rm_repo|
      rm_repo.switch :delete
      rm_repo.action do |_, opts, args|
        require "zadar/services/remove_local_iso_repo"

        call { Zadar::Services::RemoveLocalIsoRepo.new(opts.merge(name: args.first)) }
      end
    end

    iso.desc "Remove local iso files"
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
