DATA_FILES:=${INPUT_DATA_FILES}
TFPLAN_JSON:=${INPUT_TFPLAN_JSON}
CURRENT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
POLICY_DIR:="$(CURRENT_DIR)/policies"
POLICY_TYPES:=$$(find $(POLICY_DIR) -mindepth 1 -maxdepth 1 -type d -not -path '*/.*' | awk -F "/" '{print $$NF}')

.PHONY: opa

opa:

# Generate Report
	echo "#### OPA Compliance Report" > REPORT.md; \
	echo "|Category | Total | Pass | Fail | Comments|" >> REPORT.md; \
	echo "| --- | :--- | :--- | :--- | :--- |" >> REPORT.md; \
	echo "-------------------------------------"; >> REPORT.md; \
	FAILURES=0; \
	echo "Policy Types Configured => $(POLICY_TYPES)"; \
	for TYPE in $(POLICY_TYPES); do \
		for FILE in $(DATA_FILES); do \
			cp $(POLICY_DIR)/$$FILE $(POLICY_DIR)/$$TYPE; \
			cp $(TFPLAN_JSON) $(POLICY_DIR)/$$TYPE; \
		done; \
		/usr/local/bin/opa check --format json $(POLICY_DIR)/$$TYPE ; \
		RESULT=$$(/usr/local/bin/opa test $(POLICY_DIR)/$$TYPE); \
		RESULT=$$(echo $$RESULT | sed 's/-//g'); \
		COUNT=$$(echo $$RESULT | grep -o " " | wc -l); \
		if [ $$COUNT -eq 1 ]; then \
			TOTAL=$$(echo $$RESULT | cut -d " " -f 2 | cut -d "/" -f 2); \
			PASS=$$(echo $$RESULT | cut -d " " -f 2 | cut -d "/" -f 1); \
			FAIL="0"; \
			printf "| %s | %s | %s | %s | %s |\n" $$TYPE $$TOTAL $$PASS $$FAIL "No Failures" >>  REPORT.md; \
		else \
			TOTAL=$$(echo $$RESULT | cut -d " " -f $$((COUNT+1)) | cut -d "/" -f 2); \
			FAIL=$$(echo $$RESULT | cut -d " " -f $$((COUNT+1)) | cut -d "/" -f 1); \
			PASS="$$(($$TOTAL - $$FAIL))"; \
			if [ $$PASS -eq 0 ]; then \
			 	COMMENT=$$(echo $$RESULT | cut -d " " -f 1-$$((COUNT-1))); \
			else \
				COMMENT=$$(echo $$RESULT | cut -d " " -f 1-$$((COUNT-3))); \
			fi; \
			FAILURES=$$(($$FAILURES + $$FAIL)); \
			printf "| %s | %s | %s | %s | %s |\n" $$TYPE $$TOTAL $$PASS $$FAIL "$$COMMENT" >>  REPORT.md; \
		fi ; \
		for FILE in $(DATA_FILES); do rm $(POLICY_DIR)/$$TYPE/$$FILE; done; \
	done; \
	cat REPORT.md; \
	if [ $$FAILURES -gt 0 ]; then \
		echo "Total Failures => $$FAILURES"; \
		exit 1; \
	fi

comment:
	if [ "${GITHUB_EVENT_NAME}" == "pull_request" ]; then \
		PR_COMMENTS=$$(cat REPORT.md); \
		echo "Commenting on the Pull Request"; \
		PR_NUMBER=$$(echo ${GITHUB_REF} | awk -F "/" '{print $$(NF-1)}') ; \
		echo "Pull Request Number is => $$PR_NUMBER" ; \
		curl -s -H "Authorization: Bearer ${GITHUB_TOKEN}" \
 		-X POST -d '{"body": "'"OPA Policy Check Status => $$PR_COMMENTS"'"}' \
 		"https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/$$PR_NUMBER/comments" ; \
		if [ $? -ne 0 ]; then \
			exit 1; \
		fi; \
	fi

