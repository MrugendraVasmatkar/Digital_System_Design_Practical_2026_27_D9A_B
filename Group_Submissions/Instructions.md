# GitHub Instructions for Students

Read all instructions before making changes.

## A. Before you begin
1. Confirm your group of four and identify the group leader/repository owner.
2. All four students should have GitHub accounts.
3. Record names, roll numbers and GitHub usernames in the group README.
4. Open the faculty master repository and read its README and assigned problem statement.

## B. Fork the repository
1. Sign in to GitHub and open the faculty master repository.
2. Select **Fork**.
3. Select the group leader's GitHub account as owner.
4. Select **Create fork**.
5. Only the group leader should create the group's fork.

## C. Rename the fork
1. Open the fork and select **Settings**.
2. Under **General**, locate **Repository name**.
3. Rename it using `DSD-2026-CLASS-GroupNN`, e.g. `DSD-2026-D9A-Group01`.
4. Select **Rename**.

The repository name and submission folder name differ:
- Repository: `DSD-2026-D9A-Group01`
- Submission folder: `D9A_Group01`

## D. Add the other three students
1. In the group leader's fork, open **Settings**.
2. Open **Collaborators** or **Collaborators and teams**.
3. Select **Add people**, search each student's exact GitHub username and send invitations.
4. Each student must accept the invitation.
5. All four students should contribute using their own accounts. Never share passwords.

If the group leader cannot add collaborators, inform faculty. Permissions depend on repository ownership and GitHub settings.

## E. Create the group submission folder
1. In the fork, open `Group_Submissions/`.
2. Copy the contents of `Group_Template/` into a new folder named with your group ID, e.g. `D9A_Group01`.
3. Retain mandatory headings and folder names.
4. Complete the group's README and STATUS files.
5. Do not edit the faculty master repository directly.

If GitHub's web interface does not allow copying a folder, download the repository ZIP, extract it, copy the template folder and upload the completed group folder to your fork. Alternatively, use Git locally.

## F. Upload project work
| Folder | Required files |
|---|---|
| `01_Problem_Analysis` | Requirements, assumptions, input/output list and proposed solution |
| `02_FSM_Logisim` | FSM diagram/table, Logisim `.circ` file and simulation evidence |
| `03_Verilog_Implementation/RTL` | Synthesizable Verilog source |
| `03_Verilog_Implementation/Testbench` | Testbench and test vectors |
| `03_Verilog_Implementation/Simulation_Results` | Waveforms, logs and verification summary |
| `04_FPGA_Hardware` | Board/device details, constraints, implementation reports and hardware evidence |
| `05_Results` | Test cases, expected/observed comparison and conclusion |
| `06_Presentation` | Final presentation |
| `07_Final_Report` | Final project report |

Upload original source files wherever possible. Screenshots alone do not replace RTL, testbench or Logisim source files.

## G. Update README and STATUS
- Update the group README as work progresses.
- Update `STATUS.md` at least once every two hours and at every major milestone.
- Record actual completion times, evidence paths, blockers and next actions.
- Commit and push each meaningful update.

Suggested commits: `Add problem analysis`, `Upload FSM and Logisim circuit`, `Add Verilog RTL and testbench`, `Upload simulation results`, `Add FPGA results`, `Complete final report`.

## H. Final Pull Request
1. Check that all required files are present and STATUS is current.
2. Confirm your group folder is under `Group_Submissions/`.
3. In your fork, select **Contribute** → **Open pull request** (or **Compare & pull request**).
4. Confirm the **base repository** is the faculty master repository and the **base branch** is the branch specified by faculty (normally `main`).
5. Confirm the **head repository** is your fork and the compare branch contains your submission.
6. Ensure the changes add/update only your group's folder.
7. Title the PR: `Final Submission – D9A Group01 – [Project Title]`.
8. Include group ID, four student names, problem statement number and deliverables in the description.
9. Create the Pull Request and share its URL through the faculty-specified channel.
10. Do not merge your own Pull Request unless faculty instructs you to.

A Pull Request is not accepted until faculty has reviewed it.

## I. Conduct and integrity
- Every student must be able to explain the complete project.
- Do not claim simulation or hardware testing is complete without evidence.
- Identify incomplete features and limitations honestly.
- Do not copy another group's design or results.
- Follow faculty instructions for demonstration and oral examination.

## J. Troubleshooting
| Problem | Action |
|---|---|
| Fork unavailable | Check sign-in and repository fork settings; inform faculty. |
| Cannot add collaborators | Check ownership/permissions; ask faculty for an alternative. |
| Large file cannot be uploaded | Ask faculty whether Git LFS or an approved external link is permitted. |
| PR targets wrong repository | Recreate it with the faculty master as base. |
| Merge conflict | Do not overwrite another group; ask faculty for help. |
| Secret uploaded | Revoke/rotate it immediately and inform faculty; deleting the file alone may not remove it from Git history. |
