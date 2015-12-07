require 'json'
require 'httpclient'
require 'fileutils'
require 'pp'

require('./key_def.rb')
 
httpclient = HTTPClient.new()
httpclient.connect_timeout = 100
httpclient.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE

def write_result_log(msg)
	File.open("import_projects.log","a") {|file| file.puts(msg)} 
end

TARGET_PROJECTS.each do |id|
	# Project migration
	write_result_log "Project migration start"
	source = JSON.parse(httpclient.get("#{SOURCE_URL}api/v3/projects/#{id}", {'private_token' => PRIVATE_TOKEN}).body)
	write_result_log source
	params = {'private_token' => TARGET_TOKEN,'name'=>source['name'],'namespace_id'=>MEGANE_NAMESPACE}
	params['description'] = source['description'] unless source['description'].nil? 
	mig_res = httpclient.post("#{TARGET_URL}api/v3/projects", params)
	write_result_log mig_res.body
	write_result_log "Project migration end"
	
	project_id = JSON.parse(mig_res[id])['id']
	# Label
	l_res = httpclient.get("#{SOURCE_URL}api/v3/projects/#{id}/labels", {'per_page'=> PER_PAGE,'private_token' => PRIVATE_TOKEN})
	write_result_log(l_res.body)
	JSON.parse(l_res.body).each do |res|
		write_result_log(res)
		params = {'private_token' => ALTER_NOT_FOUND_TOKEN,'color'=>res['color'],'name'=>res['name']}
		r = httpclient.post("#{TARGET_URL}api/v3/projects/#{project_id}/labels",params) 
		write_result_log(r.body)
	end
	# Milestone
	mi_res = httpclient.get("#{SOURCE_URL}api/v3/projects/#{id}/milestones", {'per_page'=> PER_PAGE,'private_token' => PRIVATE_TOKEN})
	write_result_log(mi_res.body)
	JSON.parse(mi_res.body).each do |res|
		write_result_log(res)
		params = {'private_token' => ALTER_NOT_FOUND_TOKEN,'title'=>res['title']}
		params['description'] = res['description'] unless res['description'].nil? 
		params['due_date'] = res['due_date'] unless res['due_date'].nil? 
		write_result_log(params)
		r = httpclient.post("#{TARGET_URL}api/v3/projects/#{project_id}/milestones",params) 
		write_result_log(r.body)
	end
	
	# issue
	write_result_log('Issue New')
    i_res = httpclient.get("#{SOURCE_URL}api/v3/projects/#{id}/issues", {'per_page'=> PER_PAGE,'private_token' => PRIVATE_TOKEN})
	JSON.parse(i_res.body).each do |res|
		write_result_log(res)
		# issueÅÐÏ¿
		token = (USER_IDS[res['author']['id']] || ALTER_NOT_FOUND_USER)[:token]
		params = {'private_token' => token,'title'=>res['title'],'title'=>res['title']}
		unless res['assignee'].nil? 
			params['assignee_id'] = USER_IDS[res['assignee']['id']] || ALTER_NOT_FOUND_USER  
		end
		params['description'] = res['description'] unless res['description'].nil? 
		params['milestone_id'] = res['milestone']['id'] unless res['milestone'].nil? 
		params['labels'] = res['labels'] unless res['labels'].empty? 

		write_result_log("Issue Regist Prams:#{params}")
		r = httpclient.post("#{TARGET_URL}api/v3/projects/#{project_id}/issues",params) 
		write_result_log("Issue Regist Result:#{r.body}")
		# status Update
		unless res['state'] == 'opened'
			write_result_log('Status Upd')
			e_res = httpclient.post(
					"#{TARGET_URL}api/v3/projects/#{project_id}/issues/#{Json.parse(r.body)['id']}",
					{'_method'=>'put','private_token' => token,'state_event'=>(res['state'] == 'closed' ? 'close':'merge')}
				)
			write_result_log(e_res.body)
		end
	end
	write_result_log('Issue End')
	
	# Merge Request
	write_result_log('Merge New')
    m_res = httpclient.get("#{SOURCE_URL}api/v3/projects/#{id}/merge_requests", {'per_page'=> PER_PAGE,'private_token' => PRIVATE_TOKEN})
    write_result_log(m_res.body)
	JSON.parse(m_res.body).each do |res|
		# New
		write_result_log(res)
		token = (USER_IDS[res['author']['id']] || ALTER_NOT_FOUND_USER)[:token]
		params = {'private_token' => token,'source_branch'=>res['source_branch'],'target_branch'=>res['target_branch'],'title'=>res['title'],'target_project_id'=>project_id}
		unless res['assignee'].nil? 
			params['assignee_id'] = USER_IDS[res['assignee']['id']] || ALTER_NOT_FOUND_USER  
		end
		params['description'] = res['description'] unless res['description'].nil?
		write_result_log("MergeRequest Regist Prams:#{params}")
		r = httpclient.post("#{TARGET_URL}api/v3/projects/#{project_id}/merge_requests",params) 
		write_result_log("MergeRequest Regist Result:#{r.body}")	
		json = JSON.parse(r.body)	
		# status Update
		unless res['state'] == 'opened'
			write_result_log('Status Upd')
			e_res = httpclient.post(
					"#{TARGET_URL}api/v3/projects/#{project_id}/merge_request/#{json['id']}",
					{'_method'=>'put','private_token' => token,'state_event'=>(res['state'] == 'closed' ? 'close':'merge')}
				)
			write_result_log(e_res.body)
		end
	end
	write_result_log('Merge End')	
end
