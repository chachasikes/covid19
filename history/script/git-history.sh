#!/bin/bash
# NOTE: make sure line endings are not CRLF
# CSV headers
headers="id,git_filename,git_industry_category_key,git_pdf_template_type,git_pdf_language,git_permalink,git_date_updated,github_url,git_publishing_status,git_commit_author,git_commit_subject,git_download_url,git_type_document,git_commit_hash,git_commit_hash_abbreviated,git_repository,git_filepath,git_change_type"
repo="https://github.com/cagov/covid19/"
# CSV Filename
filename="./history/csv/pdf-history.csv"
# Delete old CSV file
rm -rf ${filename}
# Make new CSV file
touch ${filename}
# Insert headers into CSV file
echo ${headers} >> ${filename}
# Determine where in the git history to load data from
startCommit="master"
# Target folder
folder=""
# Path to where these files are hosted on the web
public_url="https://files.covid19.ca.gov/pdf/"
# Show total commits in the history of this folder
echo "Total Commits"
git log --pretty=format:'' | wc -l
# Split headers into an array
IFS=',' read -r -a headersArray <<< "$headers"
# Build history
get_history () {
# Set the type of git status change we are retrieving (example A D M, Added, Deleted, Modified)
type_change=$1
# For each file
# of all commits of current type of change (example: A - Added).
# Load the full git history
# Filtered by search parameters
# @TODO abstract ${folder}*uidance* ${folder}*hecklist* (try again, did not work out the first time)
# Sort results
# Remove empty lines
for file in $(git log ${startCommit} --pretty=format: --name-only --diff-filter=${type_change} --all --full-history -- ${folder}*uidance* ${folder}*hecklist* | sort - | sed '/^$/d');
do
    # Build format string for CSV data
    formatString=""
    for i in "${headersArray[@]}"
    do
        if [[ $i == "github_url" ]]
            then
                formatString+="${repo}blob/%H/${file},"
        elif [[ $i == "git_download_url" ]]
            then
                formatString+="${repo}raw/%H/${file},"
        elif [[ $i == "git_permalink" ]]
            then
                filestring=${file//pdf\//}
                formatString+="${public_url}${filestring},"
        elif [ $i == "git_industry_category_key" ];
            then
            if [[ $file =~ .*"hecklist".* ]];
                then
                odi_industry_category_key=${file//pdf\/checklist-/}
                odi_industry_category_key=${odi_industry_category_key//.pdf/}
                odi_industry_category_key=${odi_industry_category_key//.PDF/}
                odi_industry_category_key=${odi_industry_category_key//--ar/}
                odi_industry_category_key=${odi_industry_category_key//--zh-Hans/}
                odi_industry_category_key=${odi_industry_category_key//.download.zip/}
                odi_industry_category_key=${odi_industry_category_key//--en/}
                odi_industry_category_key=${odi_industry_category_key//--es/}
                odi_industry_category_key=${odi_industry_category_key//--hmn/}
                odi_industry_category_key=${odi_industry_category_key//--hy/}
                odi_industry_category_key=${odi_industry_category_key//--km/}
                odi_industry_category_key=${odi_industry_category_key//--ko/}
                odi_industry_category_key=${odi_industry_category_key//--ru/}
                odi_industry_category_key=${odi_industry_category_key//--th/}
                odi_industry_category_key=${odi_industry_category_key//--tl/}
                odi_industry_category_key=${odi_industry_category_key//--vi/}
                odi_industry_category_key=${odi_industry_category_key//--zh-tw/}
                odi_industry_category_key=${odi_industry_category_key//--zh-hans/}
                odi_industry_category_key=${odi_industry_category_key//--zh-hant/}
                odi_industry_category_key=${odi_industry_category_key//--zh-cn/}
                odi_industry_category_key=${odi_industry_category_key//--pa/}
                odi_industry_category_key=${odi_industry_category_key//-ar/}
                odi_industry_category_key=${odi_industry_category_key//-es/}
                odi_industry_category_key=${odi_industry_category_key//-ko/}
                odi_industry_category_key=${odi_industry_category_key//-tl/}
                odi_industry_category_key=${odi_industry_category_key//-zh-hans/}
                odi_industry_category_key=${odi_industry_category_key//-zh-hant/}
                odi_industry_category_key=${odi_industry_category_key//_tl/}
                odi_industry_category_key=${odi_industry_category_key//_es/}
                odi_industry_category_key=${odi_industry_category_key//-ES/}
                odi_industry_category_key=${odi_industry_category_key//_Arabic/}
                odi_industry_category_key=${odi_industry_category_key//_CH_Simplified/}
                odi_industry_category_key=${odi_industry_category_key//_Tagalog/}
                odi_industry_category_key=${odi_industry_category_key//_Korean/}
                odi_industry_category_key=${odi_industry_category_key//_CH_Simplified/}
                odi_industry_category_key=${odi_industry_category_key//_Vietnamese/}
                odi_industry_category_key=${odi_industry_category_key//-vi/}
                formatString+="\"${odi_industry_category_key}\","
            elif [[ $file =~ .*"uidance".* ]];
                then
                odi_industry_category_key=${file//pdf\/guidance-/}
                odi_industry_category_key=${odi_industry_category_key//.pdf/}
                odi_industry_category_key=${odi_industry_category_key//.PDF/}
                odi_industry_category_key=${odi_industry_category_key//--ar/}
                odi_industry_category_key=${odi_industry_category_key//--zh-Hans/}
                odi_industry_category_key=${odi_industry_category_key//.download.zip/}
                odi_industry_category_key=${odi_industry_category_key//--en/}
                odi_industry_category_key=${odi_industry_category_key//--es/}
                odi_industry_category_key=${odi_industry_category_key//--hmn/}
                odi_industry_category_key=${odi_industry_category_key//--hy/}
                odi_industry_category_key=${odi_industry_category_key//--km/}
                odi_industry_category_key=${odi_industry_category_key//--ko/}
                odi_industry_category_key=${odi_industry_category_key//--ru/}
                odi_industry_category_key=${odi_industry_category_key//--th/}
                odi_industry_category_key=${odi_industry_category_key//--tl/}
                odi_industry_category_key=${odi_industry_category_key//--vi/}
                odi_industry_category_key=${odi_industry_category_key//--zh-tw/}
                odi_industry_category_key=${odi_industry_category_key//--zh-hans/}
                odi_industry_category_key=${odi_industry_category_key//--zh-hant/}
                odi_industry_category_key=${odi_industry_category_key//--zh-cn/}
                odi_industry_category_key=${odi_industry_category_key//--pa/}
                odi_industry_category_key=${odi_industry_category_key//-ar/}
                odi_industry_category_key=${odi_industry_category_key//-es/}
                odi_industry_category_key=${odi_industry_category_key//-ko/}
                odi_industry_category_key=${odi_industry_category_key//-tl/}
                odi_industry_category_key=${odi_industry_category_key//-zh-hans/}
                odi_industry_category_key=${odi_industry_category_key//-zh-hant/}
                odi_industry_category_key=${odi_industry_category_key//_tl/}
                odi_industry_category_key=${odi_industry_category_key//_es/}
                odi_industry_category_key=${odi_industry_category_key//-ES/}
                odi_industry_category_key=${odi_industry_category_key//_Arabic/}
                odi_industry_category_key=${odi_industry_category_key//_CH_Simplified/}
                odi_industry_category_key=${odi_industry_category_key//_Tagalog/}
                odi_industry_category_key=${odi_industry_category_key//_Korean/}
                odi_industry_category_key=${odi_industry_category_key//_CH_Simplified/}
                odi_industry_category_key=${odi_industry_category_key//_Vietnamese/}
                odi_industry_category_key=${odi_industry_category_key//-vi/}
                formatString+="\"${odi_industry_category_key}\","
            else
                formatString+="Other,"
            fi
        elif [ $i == "git_filename" ];
            then
            filestring=${file//pdf\//}
            formatString+="${filestring},"
        elif [ $i == "git_date_updated" ];
            then
            formatString+="\"%ad\","
        elif [ $i == "git_commit_author" ];
            then
            formatString+="%an,"
        elif [ $i == "git_pdf_template_type" ];
            then
            if [[ "$file" == *"immigrant_guidance"* ]];
                then
                # echo "found"
                formatString+="General-IG,"
            elif [[ "$file" == *"great-plates"* ]];
                then
                # echo "found"
                formatString+="General-GP,"
            elif [[ "$file" =~ ."hecklist".* ]];
                then
                formatString+="Checklist,"
            elif [[ "$file" =~ ."uidance".* ]];
                then
                formatString+="Guidance,"
            else
                formatString+="General,"
            fi
        elif [ $i == "git_pdf_language" ];
            then
            if [[ $file =~ .*"-ko".* ]] || [[ $file =~ .*"_Korean".*  ]];
                then
                formatString+="Korean,"
            elif [[ $file =~ .*"-Vietnamese".* ]] || [[ $file =~ .*"-vi".* ]] || [[ $file =~ .*"_Vietnamese".* ]];
                then
                formatString+="Vietnamese,"
            elif [[ $file =~ .*"-pa".* ]] || [[ $file =~ .*"_Punjabi".* ]];
                then
                formatString+="Punjabi,"
            elif [[ $file =~ .*"-ar".* ]] || [[ $file =~ .*"_Arabic".* ]];
                then
                formatString+="Arabic,"
            elif [[ $file =~ .*"-zh-Hans".* ]] || [[ $file =~ .*"-zh-ch".* ]] || [[ $file =~ .*"-zh-hans".* ]] || [[ $file =~ .*"_CH_Simplified".* ]];
                then
                formatString+="Chinese-Simplified,"
            elif [[ $file =~ .*"-zh-hant".* ]] || [[ $file =~ .*"-zh-Hant".*  ]] || [[ $file =~ .*"-zh-tw".*  ]] || [[ $file =~ .*"-zh-cn".*  ]];
                then
                formatString+="Chinese-Traditional,"
            elif [[ $file =~ .*"_Tagalog".*  ]] || [[ $file =~ .*"-tl".*  ]] || [[ $file =~ .*"_tl".*  ]];
                then
                formatString+="Tagalog,"
            elif [[ $file =~ .*"--th".*  ]];
                then
                formatString+="Thai,"
            elif [[ $file =~ .*"--ru".*  ]];
                then
                formatString+="Russian,"
            elif [[ $file =~ .*"--km".*  ]];
                then
                formatString+="Khmer,"
            elif [[ $file =~ .*"--hmn".*  ]];
                then
                formatString+="Hmong,"
            elif [[ $file =~ .*"_Spanish".*  ]] || [[ $file =~ .*"-es".*  ]] || [[ $file =~ .*"_es".*  ]] || [[ $file =~ .*"-ES".*  ]];
                then
                formatString+="Spanish,"
            elif [[ $file =~ .*"_Armenian".*  ]] || [[ $file =~ .*"-hy".*  ]];
                then
                formatString+="Armenian,"
            elif [[ $file =~ .*"_Cambodian".*  ]] || [[ $file =~ .*"-km".*  ]];
                then
                formatString+="Cambodian,"
            else
                formatString+="English,"
            fi
        elif [ $i == "git_commit_subject" ];
            then
            formatString+="\"%s\","
        elif [ $i == "git_type_document" ];
            then
            formatString+="PDF,"
        elif [ $i == "git_publishing_status" ];
            then
            formatString+="\"Git-History\","
        elif [ $i == "git_filepath" ];
            then
            formatString+="${file},"
        elif [ $i == "git_change_type" ];
            then
            if [[ $type_change == "A" ]]
                then
                    formatString+="Added,"
            elif [[ $type_change == "D" ]]
                then
                    formatString+="Deleted,"
            elif [[ $type_change == "M" ]]
                then
                    formatString+="Modified,"
            fi
        elif [ $i == "git_repository" ];
            then
            formatString+="${repo},"
        elif [ $i == "git_commit_hash" ];
            then
            formatString+="\"%H\","
        elif [ $i == "git_commit_hash_abbreviated" ];
            then
            formatString+="\"%h\","
        else
            formatString+=","
        fi
    done
    # echo ${formatString}
    git log --date=iso --format=${formatString} --all --full-history --diff-filter=${type_change} --no-merges -- ${file} >> ${filename}
done
}

# Run through the different types of commits we want to store
# Select only files that are Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R), have their type (i.e. regular file, symlink, submodule, …​) changed (T), are Unmerged (U), are Unknown (X), or have had their pairing Broken (B).
get_history A
get_history C
get_history D
get_history M
get_history R
get_history X
get_history B
