-- ─────────────────────────────────────────────────────────────────────────
-- Single source of truth for the 3 departments / 13 jobs in this resource.
-- Keep the `jobs` lists here in sync with Config.JobGroups in esx_society's
-- config.lua (boss-menu "Change Job" branch switcher) and with
-- Config.emergencyJobs in esx_tracker's config.lua (map visibility).
-- ─────────────────────────────────────────────────────────────────────────
Departments = {
	{ id = 'doj',   label = 'Department Of Justice', jobs = { 'cid', 'cia', 'marshal', 'fbi', 'judge', 'doa' } },
	{ id = 'le',    label = 'Law Enforcement',        jobs = { 'police', 'sheriff', 'mt' } },
	{ id = 'organ', label = 'Organ Services',         jobs = { 'taxi', 'mechanic', 'ambulance', 'weazel' } },
}

-- Returns the department table {id, label, jobs} that `job` belongs to, or nil.
function GetDepartmentForJob(job)
	for _, dept in ipairs(Departments) do
		for _, j in ipairs(dept.jobs) do
			if j == job then return dept end
		end
	end
	return nil
end

-- Returns { [jobName] = true, ... } for every job in the same department as `job`.
function GetDepartmentJobSet(job)
	local dept = GetDepartmentForJob(job)
	if not dept then return nil end
	local set = {}
	for _, j in ipairs(dept.jobs) do set[j] = true end
	return set
end
