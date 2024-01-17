Tasks Completed:

Date Conversion:

Converted the datetime format in the "SaleDate" column to a more manageable date format.
Handling Null Values:

Identified rows with null values in the "PropertyAddress" column.
Set the address of rows with the same "ParcelID" to be the same.
Address Column Transformation:

Split the "PropertyAddress" column into "HousePropertyAddress" and "HousePropertyCity" columns.
Owner Address Transformation:

Split the "OwnerAddress" column into "OwnerPropertyAddress," "OwnerPropertyCity," and "OwnerPropertyState" columns.
Consistent Values:

Made data consistent in the "SoldAsVacant" column, replacing 'N' with 'NO' and 'Y' with 'YES'.
Duplicate Removal:

Identified and removed duplicate rows using Common Table Expressions (CTEs) based on specific column combinations.
Column Removal:

Removed unused columns like "OwnerAddress," "PropertyAddress," and "SaleDate" from the dataset.


Purpose:
The project's aim is to demonstrate how SQL queries can be utilized for data cleaning tasks, making the dataset more organized, consistent, and suitable for further analysis.

Feel free to explore the queries and adapt them to your specific dataset or use case.

