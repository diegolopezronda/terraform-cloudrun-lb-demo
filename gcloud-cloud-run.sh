#!/bin/bash

gcloud run deploy $1 --image $2 --region $3 --platform managed --allow-unauthenticated