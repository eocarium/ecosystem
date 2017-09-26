job 'creator' do
  description 'creates and modifies pipelines.
each pipeline being tied to branch in git.
this job monitors all branches.
new jobs are always disabled.
if an existing job is enable it will remain enabled.'

  def name
    return @name unless @name.nil?
    @name = [
      project_name,
      job_short_name
    ].join(environment.delimiter)
  end

  def assigned_node
    'master'
  end

  properties do
    history_retention do
      set_to_default_30_days_or_120_builds
    end
  end

  scm do
    git do
      credentials_id '448a8313-a9ab-4093-8b8e-c42bfea4491c'
      included_regions 'jenkins/.*/Smithersfile'

      branch_name '**'
    end
  end

  triggers do
    github_push do

    end
  end

  build_wrappers do
    ansicolor do
    end
  end

  builders do
    bash do
      script '#!/usr/bin/env bash

set +xe

export PATH=/usr/local/sbin:/usr/local/bin:$PATH
export WORKSPACE_SETTING=fake
export ENABLE_BASELINE_WORKSPACE_CHEF=false
export CREATE_MACHINE_REPORT=false

source .ecosystem

export HATS=jenkins
rake create_or_update_jobs
'
    end
  end

end
