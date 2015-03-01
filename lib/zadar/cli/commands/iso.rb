zadar do
  desc "Manage iso images and repositories"
  command :iso do |iso|
    iso.desc "List iso images and repos"
    iso.command :list do |list|
      list.action do |_, options, _|
        require 'zadar/services/find_iso_repos'

        repos = Zadar::Services::FindIsoRepos.new.call.repos
        puts Zadar::Models::IsoRepo.columns.columnize
        repos.each {|r| puts r.to_hash.values.columnize }
      end
    end

    iso.desc "Add and remove iso repositories"
    iso.command :addrepo do |addrepo|
      addrepo.flag [:p, :path]
      addrepo.flag [:n, :name]
      addrepo.action do |_, opts,_|
        require 'zadar/services/add_new_iso_repo'
        call { Zadar::Services::AddNewIsoRepo.new(opts) }
      end
    end
  end
end
