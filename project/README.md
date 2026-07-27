# Project Tasks


## Additional tasks for August 4th TBD
- See below for previous tasks.
- There is a (much) updated grammar under [docs/ver1.0/grammar/](docs/ver1.0/grammar/).
- The new grammar is presented in [docs/ver1.0/grammar/iStarX.md](docs/ver1.0/grammar/iStarX.md). The complete XSD is under [docs/ver1.0/grammar/iStarX.xsd](docs/ver1.0/grammar/iStarX.xsd)
	- The two must stay syncronized.
- What to do:
	- [ ] Using `xjc` generate the class model.
	- [ ] See if you can unmarshal `meetingScheduler.xml` into an in-memory object model without any customization and/or scope what work will be needed.

## Week of August 4th TBD
- [ ] Check the multi-agent integration solution proposed as per the email to the group.
- [ ] Study the new grammar and re-familizarize yourself with your unmarshaller.
- [ ] Finish the repo update tasks from the previous week.
- There will be an updated grammar and class diagram.

<!--
## 2026-07-13 
- Study the translation pattern under [docs/ver1.0/examples/translationpatterns](docs/ver1.0/examples/translationpatterns).
	- [ ] Run the pattern.pl, using indigolog
	- [ ] Read the code to observe how it works.
- Turn the single-file solution to a multi-file solution using ZeroMQ and native indigolog devices.
	- [ ] Break the pattern in two files. One with the scheduling and communication agent and one with the polling agent.
	- [ ] Update execute (line 22) to transmit the message via sockets to the python adapter. 
		- Python adapter sends to broker who then sends to python adapter of polling agent.
	- [ ] The python adapter of polling agent causes an exogenous event to the Prolog polling agent it wraps. I believe there is a working pattern for this.
	- There are three processes running: scheduling agent Prolog >>socket<< scheduling agent Python adapter >>ZeroMQ<< polling agent Polog-wrapping Python.
	- Ideally the above are four: scheduling agent Prolog >>socket<< scheduling agent Python adapter >>ZeroMQ<< polling agent Python adapter >>socket<< polling agent Prolog.

-->



## 2026-07-13 
- Study the new grammar:
	- [ ] Study the proposed changes in the grammar [docs/ver1.0/grammar/](docs/ver1.0/grammar/).
	- [ ] Look at the meeting scheduling example under [docs/ver1.0/examples/](docs/ver1.0/examples/)
	- [ ] Gather any issues, discrepancies or suboptimal choices.
- [ ] Study cnsim project, and copy from there project-related components including:
	- [ ] `src/site` and contributor documentation.
	- [ ] Documentation generation process.
	- [ ] JaCoCo generation process.
- [ ] Simplify installation process
