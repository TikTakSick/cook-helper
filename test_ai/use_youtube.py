# url：https://pypi.org/project/youtube-transcript-api/
from youtube_transcript_api import YouTubeTranscriptApi

video_id = "fSzrkRtycdU"
transcript_list = YouTubeTranscriptApi.get_transcript(video_id, languages=['ja'])
for transcript in transcript_list:
    print(transcript['text'], end = "")
