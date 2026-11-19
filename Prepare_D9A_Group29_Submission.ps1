$ErrorActionPreference = 'Stop'

# Run this script from the root of your cloned/downloaded group repository.
$repoRoot = (Get-Location).Path
$templateRoot = Join-Path $repoRoot 'Group_Template'
$submissionRoot = Join-Path $repoRoot 'Group_Submissions'
$groupRoot = Join-Path $submissionRoot 'D9A_Group29'
$vivadoSource = Join-Path $templateRoot '03_Verilog_Implementation\age_group_fsm'

if (-not (Test-Path (Join-Path $repoRoot 'Instructions.md'))) {
    throw 'Instructions.md was not found. Open PowerShell in the repository root and run this script again.'
}
if (-not (Test-Path $templateRoot)) {
    throw 'Group_Template was not found. The repository ZIP/clone may be incomplete.'
}
if (-not (Test-Path $vivadoSource)) {
    throw 'The existing age_group_fsm Vivado project folder was not found in Group_Template.'
}

# Do not silently overwrite an existing group's work.
if (Test-Path $groupRoot) {
    $existingFiles = @(Get-ChildItem -LiteralPath $groupRoot -Recurse -File -ErrorAction SilentlyContinue)
    if ($existingFiles.Count -gt 0) {
        throw "The target folder already contains $($existingFiles.Count) file(s): $groupRoot. Back it up or inspect it before running this script; no existing files were overwritten."
    }
}

New-Item -ItemType Directory -Force -Path $submissionRoot | Out-Null
New-Item -ItemType Directory -Force -Path $groupRoot | Out-Null

# Required top-level deliverable folders from Instructions.md.
$folders = @(
    '01_Problem_Analysis',
    '02_FSM_Logisim',
    '03_Verilog_Implementation\RTL',
    '03_Verilog_Implementation\Testbench',
    '03_Verilog_Implementation\Simulation_Results',
    '04_FPGA_Hardware',
    '05_Results',
    '06_Presentation',
    '07_Final_Report'
)
foreach ($folder in $folders) {
    New-Item -ItemType Directory -Force -Path (Join-Path $groupRoot $folder) | Out-Null
}

# Copy all files from the template's problem-analysis, Logisim, results,
# presentation and report folders without changing their contents.
$copyFolders = @(
    '01_Problem_Analysis',
    '02_FSM_Logisim',
    '05_Results',
    '06_Presentation',
    '07_Final_Report'
)
foreach ($folder in $copyFolders) {
    $src = Join-Path $templateRoot $folder
    if (Test-Path $src) {
        Copy-Item -Path (Join-Path $src '*') -Destination (Join-Path $groupRoot $folder) -Recurse -Force
    }
}

# Preserve the template's original top-level README/STATUS and the Verilog/FPGA
# folder notes separately, alongside the completed group-specific documentation.
$templateReadme = Join-Path $templateRoot 'README.md'
$templateStatus = Join-Path $templateRoot 'STATUS.md'
if (Test-Path $templateReadme) { Copy-Item -LiteralPath $templateReadme -Destination (Join-Path $groupRoot 'README_TEMPLATE.md') -Force }
if (Test-Path $templateStatus) { Copy-Item -LiteralPath $templateStatus -Destination (Join-Path $groupRoot 'STATUS_TEMPLATE.md') -Force }

$verilogTemplateNote = Join-Path $templateRoot '03_Verilog_Implementation\README.md'
if (Test-Path $verilogTemplateNote) {
    Copy-Item -LiteralPath $verilogTemplateNote -Destination (Join-Path $groupRoot '03_Verilog_Implementation\Template_README.md') -Force
}
$fpgaTemplateNote = Join-Path $templateRoot '04_FPGA_Hardware\README.md'
if (Test-Path $fpgaTemplateNote) {
    Copy-Item -LiteralPath $fpgaTemplateNote -Destination (Join-Path $groupRoot '04_FPGA_Hardware\Template_README.md') -Force
}

# Keep the original complete Vivado project intact under FPGA hardware.
# This retains the .xpr, source tree, constraints, simulation setup, run logs,
# implementation reports, generated checkpoints and bitstream as uploaded.
$vivadoArchive = Join-Path $groupRoot '04_FPGA_Hardware\Vivado_Project\age_group_fsm'
New-Item -ItemType Directory -Force -Path (Split-Path $vivadoArchive -Parent) | Out-Null
Copy-Item -Path $vivadoSource -Destination $vivadoArchive -Recurse -Force

# Place the directly required editable RTL and testbench at the exact locations
# specified by Instructions.md, in addition to preserving the full Vivado project.
$rtlSource = Join-Path $vivadoSource 'age_group_fsm.srcs\sources_1\new\age_group_detector_core.v'
$tbSource = Join-Path $vivadoSource 'age_group_fsm.srcs\sim_1\new\tb_age_group_detector.v'
$xdcSource = Join-Path $vivadoSource 'age_group_fsm.srcs\constrs_1\new\age_group_detector_boolean.xdc'
$simSource = Join-Path $vivadoSource 'age_group_fsm.sim\sim_1\behav\xsim'

foreach ($requiredFile in @($rtlSource, $tbSource, $xdcSource)) {
    if (-not (Test-Path $requiredFile)) { throw "Required supplied project file is missing: $requiredFile" }
}
Copy-Item -LiteralPath $rtlSource -Destination (Join-Path $groupRoot '03_Verilog_Implementation\RTL\age_group_detector_core.v') -Force
Copy-Item -LiteralPath $tbSource -Destination (Join-Path $groupRoot '03_Verilog_Implementation\Testbench\tb_age_group_detector.v') -Force
Copy-Item -LiteralPath $xdcSource -Destination (Join-Path $groupRoot '04_FPGA_Hardware\age_group_detector_boolean.xdc') -Force

# Put the supplied XSim run files (logs, Tcl, WDB waveform database, etc.)
# in Simulation_Results while also retaining their original project copies.
if (Test-Path $simSource) {
    $xsimDest = Join-Path $groupRoot '03_Verilog_Implementation\Simulation_Results\XSim'
    New-Item -ItemType Directory -Force -Path $xsimDest | Out-Null
    Copy-Item -Path (Join-Path $simSource '*') -Destination $xsimDest -Recurse -Force
}

# Copy human-readable Vivado implementation/synthesis reports into the FPGA
# deliverable folder; keep generated .pb/.dcp and other artefacts in the archive.
$runsRoot = Join-Path $vivadoSource 'age_group_fsm.runs'
$reportsDest = Join-Path $groupRoot '04_FPGA_Hardware\Implementation_Reports'
New-Item -ItemType Directory -Force -Path $reportsDest | Out-Null
if (Test-Path $runsRoot) {
    Get-ChildItem -LiteralPath $runsRoot -Recurse -File -Filter '*.rpt' | ForEach-Object {
        $relative = $_.FullName.Substring($runsRoot.Length).TrimStart('\')
        $destination = Join-Path $reportsDest $relative
        New-Item -ItemType Directory -Force -Path (Split-Path $destination -Parent) | Out-Null
        Copy-Item -LiteralPath $_.FullName -Destination $destination -Force
    }
}

# Copy generated bitstream(s) to an obvious FPGA deliverable location.
$bitDest = Join-Path $groupRoot '04_FPGA_Hardware\Bitstream'
New-Item -ItemType Directory -Force -Path $bitDest | Out-Null
Get-ChildItem -LiteralPath $vivadoSource -Recurse -File -Filter '*.bit' | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $bitDest $_.Name) -Force
}

# Add concise directory guides without asserting that simulation or board tests passed.
$guides = @{
    '03_Verilog_Implementation\README.md' = @'
# Verilog Implementation

- `RTL/` contains the editable synthesizable Verilog source copied from the supplied project.
- `Testbench/` contains the editable testbench copied from the supplied project.
- `Simulation_Results/` contains the supplied XSim logs and waveform database. Re-run against the final RTL before claiming final verification.
- `Vivado_Project/` is not used here; the complete original Vivado project is preserved under `04_FPGA_Hardware/Vivado_Project/`.

**Version note:** The supplied project snapshot currently declares a 6-bit age input. The latest intended H3 version may be different. This is a preserved starting snapshot, not certification of the final 5-bit implementation.
'@
    '04_FPGA_Hardware\README.md' = @'
# FPGA Hardware

- `age_group_detector_boolean.xdc` is the supplied constraints file; verify the part, board pinout and I/O standards against the physical board.
- `Vivado_Project/age_group_fsm/` preserves the complete uploaded Vivado project, including its original relative paths and generated files.
- `Implementation_Reports/` contains the supplied readable `.rpt` files.
- `Bitstream/` contains the supplied `.bit` file(s).
- Add board/device details, implementation summary and direct hardware demonstration evidence here after checking them.

The presence of an existing bitstream or report does not by itself prove that it matches the latest RTL or that it was programmed and tested on the physical board.
'@
}
foreach ($entry in $guides.GetEnumerator()) {
    $destination = Join-Path $groupRoot $entry.Key
    Set-Content -LiteralPath $destination -Value $entry.Value -Encoding UTF8
}

# Create group README with all required documentation headings and honest pending fields.
$readme = @'
# Digital System Design — Group Project Submission

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Kaif Bagwan | **Pending** | [kaifjbagwan4116-coder](https://github.com/kaifjbagwan4116-coder) |
| Member 2 | Karthik (full name to confirm) | **Pending** | [2025kartikmishra-debug](https://github.com/2025kartikmishra-debug) |
| Member 3 | Vedant (full name to confirm) | **Pending** | [vedantpathare1137-crypto](https://github.com/vedantpathare1137-crypto) |
| Member 4 | Arya (full name to confirm) | **Pending** | [d2026aryaukirde-max](https://github.com/d2026aryaukirde-max) |

**Class:** D9A  
**Group ID:** D9A_Group29  
**Assigned problem statement:** H3  
**Repository:** https://github.com/kaifjbagwan4116-coder/DSD-2026-D9A-Group29  
**Final Pull Request:** Pending

## 2. Assigned Problem Statement
H3 is the assigned problem statement. Copy the official title and exact problem statement wording here. Validate the requirements, assumptions and solution against the faculty-provided statement.

## 3. Problem Analysis and Proposed Solution
See `01_Problem_Analysis/`. Complete requirements, assumptions, input/output list and proposed solution using the official H3 statement.

## 4. Architecture
Add the final block diagram and explain modules, data/control flow and design decisions.

## 5. FSM Design
See `02_FSM_Logisim/`. Add the final FSM diagram, state table, transitions and reset behaviour. Ensure they match the final RTL.

## 6. Logisim Implementation
- Circuit source: `02_FSM_Logisim/DSDlogs.circ`
- Add Logisim version, simulation cases and evidence when verified.

## 7. Verilog HDL Implementation
- Synthesizable source: `03_Verilog_Implementation/RTL/`
- Testbench and vectors: `03_Verilog_Implementation/Testbench/`
- Simulation evidence: `03_Verilog_Implementation/Simulation_Results/`
- Complete original Vivado project: `04_FPGA_Hardware/Vivado_Project/age_group_fsm/`

**Version note:** The supplied RTL snapshot declares a 6-bit age input. The latest intended H3 implementation may differ. Reconcile the RTL, testbench and hardware outputs with the final 5-bit version before final submission.

## 8. Verification and Simulation Results
Place final waveforms, logs and verification summary in `03_Verilog_Implementation/Simulation_Results/`. Record expected and observed results only after running the final RTL/testbench together. Existing XSim artefacts are preserved but are not certified against a later RTL revision.

## 9. FPGA Hardware Implementation
- Constraints: `04_FPGA_Hardware/age_group_detector_boolean.xdc`
- Complete project: `04_FPGA_Hardware/Vivado_Project/`
- Reports: `04_FPGA_Hardware/Implementation_Reports/`
- Bitstream: `04_FPGA_Hardware/Bitstream/`

Verify the board model, FPGA part, package pins, I/O standards and final RTL correspondence. Add direct hardware evidence after programming and testing the actual board.

## 10. Challenges, Debugging and Improvements
Record actual issues, root causes, corrections and outcomes. Do not claim a fix or test unless performed.

## 11. Task Allocation and Individual Contribution
Record each student's actual responsibilities and evidence. Every student must be able to explain the complete project.

## 12. Progress Log
See `STATUS.md`; update at least every two hours and at each major milestone with actual time, evidence, blockers and next actions.

## 13. Final Results and Conclusion
Complete after final simulation, FPGA implementation and hardware testing. State limitations honestly.

## 14. Team Reflection
Add the team's learning outcomes and proposed improvements.

## 15. Final Submission Checklist
- [ ] Full student names and roll numbers entered.
- [ ] Official H3 wording, requirements and assumptions documented.
- [ ] Architecture/block diagram included.
- [ ] FSM diagram and state table included and match final RTL.
- [ ] Logisim `.circ` source and simulation evidence included.
- [ ] Verilog RTL in `03_Verilog_Implementation/RTL/`.
- [ ] Testbench in `03_Verilog_Implementation/Testbench/`.
- [ ] Waveforms, logs and verification summary in `03_Verilog_Implementation/Simulation_Results/`.
- [ ] Board/device details, XDC, implementation reports and hardware evidence in `04_FPGA_Hardware/`.
- [ ] Test cases, expected/observed comparison and conclusion in `05_Results/`.
- [ ] Final presentation in `06_Presentation/`.
- [ ] Final report in `07_Final_Report/`.
- [ ] STATUS.md updated and evidence paths valid.
- [ ] Final Pull Request created against the faculty master repository and URL recorded.
'@
Set-Content -LiteralPath (Join-Path $groupRoot 'README.md') -Value $readme -Encoding UTF8

$timestamp = Get-Date -Format 'dd MMM yyyy HH:mm:ss zzz'
$status = @"
# Group Progress Status

**Class:** D9A  
**Group ID:** D9A_Group29  
**Assigned problem statement:** H3  
**Group leader:** Kaif Bagwan (@kaifjbagwan4116-coder)

## 1. Current milestone status
| No. | Milestone | Status | Evidence path/link | Notes |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | In Progress | `01_Problem_Analysis/` | Official H3 text and completed analysis still required |
| 2 | Architecture and block diagram prepared | Not Started | Pending | Add final diagram and explanation |
| 3 | FSM diagram/table completed | In Progress | `02_FSM_Logisim/DSDlogs.circ` | Circuit preserved; final documentation/evidence required |
| 4 | Logisim circuit implemented | In Progress | `02_FSM_Logisim/DSDlogs.circ` | Verify against final design |
| 5 | Logisim simulation verified | Not Started | Pending | Add simulation evidence |
| 6 | Verilog RTL uploaded | In Progress | `03_Verilog_Implementation/RTL/` | Supplied snapshot copied; it currently uses a 6-bit input and needs reconciliation with final H3 RTL |
| 7 | Testbench uploaded | In Progress | `03_Verilog_Implementation/Testbench/` | Supplied testbench copied; rerun against final RTL |
| 8 | Simulation results uploaded | In Progress | `03_Verilog_Implementation/Simulation_Results/` | Existing XSim files copied; final 5-bit verification pending |
| 9 | FPGA constraints and implementation outputs uploaded | In Progress | `04_FPGA_Hardware/` | XDC, Vivado project, reports and bitstream preserved; board/device correspondence must be checked |
| 10 | Hardware demonstration completed | Not Started | Pending | Direct physical-board evidence required |
| 11 | Results, presentation and report completed | Not Started | `05_Results/`, `06_Presentation/`, `07_Final_Report/` | Complete after verification |
| 12 | Final Pull Request created | Not Started | Pending | Create after final review |

## 2. Time-wise progress log
Update at least once every two hours and at every major milestone. Record actual times and evidence; do not pre-fill future work.

| Date | Actual time (IST) | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| $(Get-Date -Format 'dd MMM yyyy') | $timestamp | Prepared the submission directory structure and copied the currently supplied template/project files into their required deliverable folders using the setup script | `Group_Submissions/D9A_Group29/` | Roll numbers/full names and official H3 text pending; supplied RTL snapshot is 6-bit and may differ from the final intended 5-bit design | Review folder tree; complete member details; update RTL/testbench and rerun verification as the design evolves | Kaif Bagwan |

## 3. Current blockers and support required
| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| Student roll numbers and full names pending | Team section incomplete | Collect exact details from all members | No, unless roster is unavailable |
| Official H3 wording/title not transcribed | Requirements cannot be finalized | Copy exact faculty statement and validate project | Only if ambiguous |
| Supplied RTL snapshot is 6-bit | May not match latest intended H3 design | Preserve supplied source; update dedicated RTL and testbench when final source is ready | No |
| Board model/pinout not confirmed | Hardware results cannot be certified | Verify the physical board and XDC mapping | Faculty/board documentation if unavailable |

## 4. End-of-day summary
### $(Get-Date -Format 'dd MMMM yyyy')
- Completed: Prepared the required folder layout and copied the currently supplied project assets.
- In progress: README/STATUS details and checking project assets against the final H3 design.
- Pending: Roll numbers, official H3 statement, final RTL/testbench verification, board confirmation, hardware evidence, presentation and report.
- Evidence uploaded: See paths in this repository folder.

## 5. Group leader confirmation
Initial setup record only. Final confirmation should be added after reviewing the files, final RTL, simulation and evidence.

**Group leader:** Kaif Bagwan  
**Recorded at:** $timestamp
"@
Set-Content -LiteralPath (Join-Path $groupRoot 'STATUS.md') -Value $status -Encoding UTF8

# Remove only the known empty, incorrectly named placeholder file. Refuse to remove a directory or non-empty file.
$oldPlaceholder = Join-Path $submissionRoot 'D9A_GROUP29'
if (Test-Path -LiteralPath $oldPlaceholder -PathType Leaf) {
    $oldContent = Get-Content -LiteralPath $oldPlaceholder -Raw
    if (-not [string]::IsNullOrWhiteSpace($oldContent)) {
        throw "The old D9A_GROUP29 placeholder contains text. It was not removed: $oldPlaceholder"
    }
    Remove-Item -LiteralPath $oldPlaceholder -Force
}

# Validate required structure and key files.
$requiredPaths = @(
    'README.md', 'STATUS.md',
    '01_Problem_Analysis', '02_FSM_Logisim',
    '03_Verilog_Implementation\RTL\age_group_detector_core.v',
    '03_Verilog_Implementation\Testbench\tb_age_group_detector.v',
    '03_Verilog_Implementation\Simulation_Results',
    '04_FPGA_Hardware\age_group_detector_boolean.xdc',
    '05_Results', '06_Presentation', '07_Final_Report',
    '04_FPGA_Hardware\Vivado_Project\age_group_fsm'
)
$missing = @($requiredPaths | Where-Object { -not (Test-Path (Join-Path $groupRoot $_)) })
if ($missing.Count -gt 0) {
    throw "Folder setup completed with missing required paths: $($missing -join ', ')"
}

$fileCount = @(Get-ChildItem -LiteralPath $groupRoot -Recurse -File).Count
Write-Host ''
Write-Host 'D9A_Group29 folder preparation completed.' -ForegroundColor Green
Write-Host "Group folder: $groupRoot"
Write-Host "Files in group folder: $fileCount"
Write-Host 'Review the README/STATUS, then run git status before committing.'
Write-Host 'No simulation or hardware test has been newly run by this script.'
